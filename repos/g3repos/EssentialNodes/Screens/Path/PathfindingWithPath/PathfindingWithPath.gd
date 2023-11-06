extends Spatial

const LABEL_LEVEL := "LEVEL: %d"
const DIRECTIONS := [Vector3.RIGHT, Vector3.FORWARD, Vector3.UP]
## The ship's maximum speed in units per second.
const SPEED_MAX := 16.0

## The ship's current speed in units per second.
var _speed := 0.0
var _acceleration := 6.0

var _level := 0 setget _set_level
var _gridmap_aabb := AABB()
var _gridmap_offset := Vector3.ZERO
var _astar := AStar.new()

# We reference our scene's key nodes and use them for pathfinding.
onready var _camera: Camera = $Camera
onready var _gridmap: GridMap = $GridMap
onready var _halo_mesh: MeshInstance = $HaloMesh
onready var _path: Path = $Path
onready var _path_follow: PathFollow = $Path/PathFollow
onready var _label_level: Label = $LabelLevel
onready var _slider: Slider = $HBoxContainer/Slider


func _ready() -> void:
	_slider.connect("value_changed", _path.curve, "set_bake_interval")
	_slider.value = _path.curve.bake_interval
	_gridmap_offset = 0.5 * Vector3(
		int(not _gridmap.cell_center_x),
		int(not _gridmap.cell_center_y),
		int(not _gridmap.cell_center_z)
	) * _gridmap.cell_size

	_initialize_astar_graph()
	_set_level(_level)

	# The player unit is set up to move_along automatically when `_process()` is
	# activated. So we turn it off by default.
	set_process(false)

	# We need this line in node essentials to clear debug path drawings when
	# resetting scenes.
	_path.curve.clear_points()


func _initialize_astar_graph() -> void:
	# Store the `GridMap` used rectangle. This is used in `xyz_to_index()` and
	# `index_to_xyz()` too.
	_gridmap_aabb = _gridmap.get_used_aabb()

	for x in range(_gridmap_aabb.size.x):
		for y in range(_gridmap_aabb.size.y):
			for z in range(_gridmap_aabb.size.z):
				var point := Vector3(x, y, z)
				if not point in _gridmap.get_used_cells():
					var point_index := xyz_to_index(point)
					_astar.add_point(point_index, point)

	# Connect adjacent points. Since we use bi-directional connections we only
	# check for `Vector3.RIGHT`, `Vector3.FORWARD`, `Vector3.UP` offsets, as
	# defined by `DIRECTIONS`.
	for point1_index in _astar.get_points():
		var point1 := index_to_xyz(point1_index)
		for offset in DIRECTIONS:
			var point2: Vector3 = point1 + offset
			var point2_index := xyz_to_index(point2)
			if _astar.has_point(point2_index):
				_astar.connect_points(point1_index, point2_index)


func _process(delta: float) -> void:
	_speed = min(_speed + _acceleration * delta, SPEED_MAX)
	_path_follow.offset += _speed * delta

	if _path_follow.offset >= _path.curve.get_baked_length():
		_speed = 0.0
		set_process(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		move_along(find_path())
	elif event.is_action_pressed("level_up"):
		_set_level(_level + 1)
	elif event.is_action_pressed("level_down"):
		_set_level(_level - 1)

	# On mouse motion we recalculate the `HaloMesh` position based on the mouse
	# pointer.
	if event is InputEventMouseMotion:
		# We convert to map coordinates and reconvert to world coordinates in
		# order to round the `position` to the nearest `GridMap` cell.
		var position := _gridmap.world_to_map(mouse_position_to_xyz(event.position))
		_halo_mesh.translation = _gridmap.map_to_world(position.x, position.y, position.z)
		_halo_mesh.translation += _gridmap_offset


## Returns the location in 3D space based on a ray shooting from the mouse
## position and intersecting a plane that is perpendicular with `Vecctor3.UP`.
## Its depth is given by `_level`.
func mouse_position_to_xyz(mouse_position: Vector2) -> Vector3:
	# We use a small "uncertainty" to the `_level` so we won't worry about
	# rounding errors.
	return Plane(Vector3.UP, _gridmap.cell_size.y * _level + 1e-4).intersects_ray(
		_camera.project_ray_origin(mouse_position),
		_camera.project_ray_normal(mouse_position)
	)


## Gets the `AStar` point-path given by the `PathFollow` current position and
## the input `HaloMesh` position which correspond to the mouse pointer.
func find_path() -> PoolVector3Array:
	var out: PoolVector3Array = []

	# First get the start and finish `AStar` indices based on `PathFollow` and
	# respectively the mouse click locations, through `HaloMesh`.
	var start_index := xyz_to_index(_gridmap.world_to_map(_path_follow.translation))
	var finish_point := _gridmap.world_to_map(_halo_mesh.translation)
	var finish_index := xyz_to_index(finish_point)

	# We also check `_gridmap_aabb.has_point()` because `xyz_to_index` works
	# only for positive positions
	if (_gridmap_aabb.has_point(finish_point)
		and _astar.has_point(start_index)
		and _astar.has_point(finish_index)
	):
		out = _astar.get_point_path(start_index, finish_index)

	return out


## Generates a new curve based on a path output by the AStar object and turns on
## processing.
func move_along(path: Array) -> void:
	if path.empty():
		return

	_path.curve.clear_points()
	_path.curve.add_point(_path_follow.translation)

	for index in range(1, path.size()):
		var point := _gridmap.map_to_world(path[index].x, path[index].y, path[index].z)
		point += _gridmap_offset
		_path.curve.add_point(point)

	_path_follow.offset = 0.0
	set_process(true)


# We use the following two functions to convert values between grid coordinates
# and indices.
func xyz_to_index(offset: Vector3) -> int:
	return int(offset.x + _gridmap_aabb.size.x * (offset.y + _gridmap_aabb.size.y * offset.z))


func index_to_xyz(index: int) -> Vector3:
	var x := index % int(_gridmap_aabb.size.x)
	var y := (index / int(_gridmap_aabb.size.x)) % int(_gridmap_aabb.size.y)
	var z := index / int(_gridmap_aabb.size.x * _gridmap_aabb.size.y)
	return Vector3(x, y, z)


func _set_level(value: int) -> void:
	# We use `posmod()` to make sure that value never exits the `[0,
	# _gridmap_aabb.size.y]` range.
	_level = posmod(value, _gridmap_aabb.size.y)
	_label_level.text = LABEL_LEVEL % _level
