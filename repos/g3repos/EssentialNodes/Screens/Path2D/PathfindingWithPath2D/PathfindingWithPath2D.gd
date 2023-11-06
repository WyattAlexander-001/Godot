extends Node2D

## `AStar` connection directions for adjacent points.
const DIRECTIONS := [Vector2.RIGHT, Vector2.DOWN]
## The ship's maximum speed in pixels per second.
const SPEED_MAX := 550.0

var _acceleration := 1000.0
## The ship's current speed in pixels per second.
var _speed := 0.0
var _astar := AStar2D.new()
var _tilemap_rect := Rect2()

# We reference our scene's three key nodes and use them for pathfinding.
onready var _tilemap: TileMap = $TileMap
onready var _path: Path2D = $Path2D
onready var _path_follow: PathFollow2D = $Path2D/PathFollow2D
onready var _flame_main: Sprite = $Path2D/PathFollow2D/Player/FlameMain
onready var _flame_left: Sprite = $Path2D/PathFollow2D/Player/FlameLeft
onready var _flame_right: Sprite = $Path2D/PathFollow2D/Player/FlameRight
onready var _slider: Slider = $UI/HBoxContainer/Slider


func _ready() -> void:
	_initialize_astar_graph()

	# The player unit is set up to move_along automatically when `_process()` is activated.
	# So we turn it off by default.
	set_process(false)

	_slider.connect("value_changed", _path.curve, "set_bake_interval")
	_slider.value = _path.curve.bake_interval

	# We need this line in node essentials to clear debug path drawings when resetting scenes.
	_path.curve.clear_points()


func _initialize_astar_graph() -> void:
	# Store the `TileMap` used rectangle. This is used in `xy_to_index()`
	# and `index_to_xy()` too.
	_tilemap_rect = _tilemap.get_used_rect()

	# First we add all available points to `astar`, in `TileMap` coordinates.
	for x in range(_tilemap_rect.size.x):
		for y in range(_tilemap_rect.size.y):
			var point := Vector2(x, y)
			if not point in _tilemap.get_used_cells():
				var point_index := xy_to_index(point)
				_astar.add_point(point_index, point)

	# Connect adjacent points. Since we use bi-directional connections we only check for
	# `Vector2.RIGHT` and `Vector2.DOWN` offsets, as defined by `DIRECTIONS`.
	for point1_index in _astar.get_points():
		var point1 := index_to_xy(point1_index)
		for offset in DIRECTIONS:
			var point2: Vector2 = point1 + offset
			var point2_index := xy_to_index(point2)
			if _astar.has_point(point2_index):
				_astar.connect_points(point1_index, point2_index)


func _process(delta: float) -> void:
	_speed = min(_speed + _acceleration * delta, SPEED_MAX)
	_path_follow.offset += _speed * delta

	if _path_follow.offset >= _path.curve.get_baked_length():
		_speed = 0.0
		set_process(false)
	var speed_ratio := Vector2.ONE * _speed/SPEED_MAX
	_flame_main.scale = speed_ratio
	_flame_left.scale = speed_ratio * 0.35
	_flame_right.scale = speed_ratio * 0.35


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		move_along(find_path_to(event.position))


## Gets the `AStar` point-path given by the `PathFollow2D` current position and the
## input `mouse_position`.
func find_path_to(mouse_position: Vector2) -> PoolVector2Array:
	var out: PoolVector2Array = []

	# First get the start and finish `AStar` indices based on `PathFollow2D` and respectively
	# the mouse click locations.
	var start_index := xy_to_index(_tilemap.world_to_map(_path_follow.position))
	var finish_index := xy_to_index(_tilemap.world_to_map(mouse_position))
	if _astar.has_point(start_index) and _astar.has_point(finish_index):
		out = _astar.get_point_path(start_index, finish_index)

	return out


## Updates the `Path2D.curve` property based on the input `AStar` point-path and starts the
## player movement.
func move_along(path: Array) -> void:
	if path.empty():
		return

	# Clear the curve points and add the current `PathFollow2D` position as the first point.
	# This way, we can calculate new paths mid-movement.
	_path.curve.clear_points()
	_path.curve.add_point(_path_follow.position)

	# We skip the first points since we already added the `PathFollow2D` position.
	for index in range(1, path.size()):
		# Get point in world coordinates and correct for tile center.
		var point := _tilemap.map_to_world(path[index])
		point += _tilemap.cell_size / 2
		_path.curve.add_point(point)

	# Reset the `PathFollow2D` offset and enable `_process()` to start the movement.
	_path_follow.offset = 0.0
	set_process(true)


# We use the following two functions to convert values between grid coordinates
# and indices.
func xy_to_index(offset: Vector2) -> int:
	return int(offset.x + _tilemap_rect.size.x * offset.y)


func index_to_xy(index: int) -> Vector2:
	return Vector2(index % int(_tilemap_rect.size.x), index / int(_tilemap_rect.size.x))
