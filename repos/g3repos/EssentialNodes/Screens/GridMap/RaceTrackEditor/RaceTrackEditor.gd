extends Spatial
# List all the modes we support in our racetrack editor.
enum DrawingState { DRAWING, ERASING, IDLE }

const OFFSET := 0.001
# The following constants name important tile indices.
const EMPTY_CELL := -1
const STRAIGHT_ROAD := 12
const CORNER_ROAD := 7
const T_ROAD := 2
const FOUR_WAY_ROAD := 0
const CAP_ROAD := 6
# Every time we update a cell, we need to loop over its neighbors and update
# them too. This array stores the relative position of all neighbors of a cell.
const NEIGHBORS := [Vector3.FORWARD, Vector3.LEFT, Vector3.RIGHT, Vector3.BACK]
# This constant holds values for specific GridMap cell orientations. This allows
# us to rotate and reuse our road tiles as much as possible.
const ORTHOGONAL_MAP := {"North": 16, "East": 0, "South": 22, "West": 10}
# This array of dictionary maps calculated autotile indices to the cell ID and rotation.
const AUTOTILE_INDEX_MAP := [
	{
		"cell_type": CORNER_ROAD,
		"rotation_map":
		{
			3: ORTHOGONAL_MAP.West,
			5: ORTHOGONAL_MAP.North,
			10: ORTHOGONAL_MAP.South,
			12: ORTHOGONAL_MAP.East
		}
	},
	{
		"cell_type": STRAIGHT_ROAD,
		"rotation_map": {6: ORTHOGONAL_MAP.South, 9: ORTHOGONAL_MAP.West}
	},
	{
		"cell_type": T_ROAD,
		"rotation_map":
		{
			7: ORTHOGONAL_MAP.West,
			13: ORTHOGONAL_MAP.North,
			14: ORTHOGONAL_MAP.East,
			11: ORTHOGONAL_MAP.South
		}
	},
	{
		"cell_type": FOUR_WAY_ROAD,
		"rotation_map": {15: ORTHOGONAL_MAP.North}
	},
	{
		"cell_type": CAP_ROAD,
		"rotation_map":
		{
			1: ORTHOGONAL_MAP.West,
			2: ORTHOGONAL_MAP.South,
			4: ORTHOGONAL_MAP.North,
			8: ORTHOGONAL_MAP.East
		}
	},
]

var _drawing_state: int = DrawingState.IDLE
## Coordinates of the cell the player is currently hovering.
var _current_cell := Vector3.INF

onready var _gridmap: GridMap = $GridMap
onready var _camera: Camera = $Camera
onready var _preview: MeshInstance = $Preview


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update_current_cell(event.position)


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("click"):
		_drawing_state = DrawingState.DRAWING
		place_road()
	elif Input.is_action_pressed("right_click"):
		_drawing_state = DrawingState.ERASING
		erase_road()
	else:
		_drawing_state = DrawingState.IDLE


func place_road() -> void:
	_gridmap.set_cell_item(_current_cell.x, _current_cell.y, _current_cell.z, STRAIGHT_ROAD)
	update_all_autotiles()


func erase_road() -> void:
	_gridmap.set_cell_item(_current_cell.x, _current_cell.y, _current_cell.z, EMPTY_CELL)
	update_all_autotiles()


func update_all_autotiles() -> void:
	for cell in _gridmap.get_used_cells():
		# This variable is a number representing the configuration of neighbors.
		var autotile_index := 0
		# For each neighbor cell with a road, we add the corresponding power of
		# two to `autotile_index`.
		for neighbor in NEIGHBORS:
			if is_cell_empty(cell + neighbor):
				continue
			# We use the bit shifting operator `<<` here.
			#
			# Bit shifting by the index of the neighbor is equivalent to
			# calling `pow(2, index)`.
			#
			# Bitwise operations are generally much more efficient than
			# calling the pow() function.
			autotile_index += 1 << NEIGHBORS.find(neighbor)
		autotile_cell(cell, autotile_index)


func autotile_cell(cell: Vector3, autotile_index: int) -> void:
	for map in AUTOTILE_INDEX_MAP:
		if autotile_index in map.rotation_map.keys():
			_gridmap.set_cell_item(
				cell.x, cell.y, cell.z, map.cell_type, map.rotation_map[autotile_index]
			)
			return
	_gridmap.set_cell_item(cell.x, cell.y, cell.z, STRAIGHT_ROAD)


func update_current_cell(mouse_position: Vector2) -> void:
	# To ensure every cell is on the same Y level, the raycast is set to
	# intersect with a flat plane at Y = 0.
	#
	# We use the `OFFSET` constant to move the plane up a tiny amount to avoid
	# issues with world_to_map() if the intersection is on the border between
	# two cells.
	var intersection := Plane(Vector3.UP, OFFSET).intersects_ray(
		_camera.project_ray_origin(mouse_position), _camera.project_ray_normal(mouse_position)
	)
	_current_cell = _gridmap.world_to_map(intersection)
	_preview.global_transform.origin = _gridmap.map_to_world(
		_current_cell.x, _current_cell.y, _current_cell.z
	)
	
	if _drawing_state == DrawingState.DRAWING:
		place_road()
	elif _drawing_state == DrawingState.ERASING:
		erase_road()


func is_cell_empty(cell: Vector3) -> bool:
	return _gridmap.get_cell_item(cell.x, cell.y, cell.z) == EMPTY_CELL
