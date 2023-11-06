extends Spatial

# We load our mesh library to display a preview of the mesh the player's about
# to build.
const MESH_LIBRARY: MeshLibrary = preload("res://common/Environment/space_environment_meshlib.tres")
## We set the mesh preview to this green color if the player can build on the
## hovered cell.
const VALID_CELL_COLOR := Color(0.560784, 0.870588, 0.364706, 0.6)
## We set the mesh preview to this red color if the player can't build on the
## hovered cell.
const INVALID_CELL_COLOR := Color(0.921569, 0.337255, 0.294118, 0.6)

# Below are tile indices corresponding to empty cells, buildings the player can
# cycle through, and tiles over which the player can build.
const EMPTY_CELL_INDEX := -1
const BUILDING_OPTIONS := [22, 27, 29, 30, 33]
const FLOOR_CELL_IDS := [9, 12]

onready var _gridmap: GridMap = $GridMap
onready var _preview: MeshInstance = $Preview
# We need the camera to detect where the player clicks.
onready var _camera: Camera = $Camera

## The grid coordinates of the hovered cell.
var _cell := Vector3.INF
## The index of the building to place on the map.
var _building_index := 1 setget _set_building_index


func _ready() -> void:
	_update_preview_mesh()


func _unhandled_input(event: InputEvent) -> void:
	# Every time the player moves the mouse, we want to update the preview if
	# necessary.
	if event is InputEventMouseMotion:
		_update_preview()
	elif event.is_action_pressed("click") and can_build_in_hovered_cell():
		build()
	elif event.is_action_pressed("right_click"):
		erase_building()
	# The player can cycle through the list of tiles in `BUILDING_OPTIONS by
	# pressing A and D.
	elif event.is_action_pressed("ui_left"):
		_set_building_index(_building_index - 1)
	elif event.is_action_pressed("ui_right"):
		_set_building_index(_building_index + 1)


func build() -> void:
	_gridmap.set_cell_item(_cell.x, _cell.y, _cell.z, BUILDING_OPTIONS[_building_index])


# Called in _unhandled_input() when the player right clicks
func erase_building() -> void:
	if not is_cell_floor(Vector3(_cell.x, _cell.y - 1, _cell.z)):
		_gridmap.set_cell_item(_cell.x, _cell.y - 1, _cell.z, EMPTY_CELL_INDEX)
	elif not is_cell_floor(Vector3(_cell.x, _cell.y, _cell.z)):
		_gridmap.set_cell_item(_cell.x, _cell.y, _cell.z, EMPTY_CELL_INDEX)


func can_build_in_hovered_cell() -> bool:
	return is_hovered_cell_empty() and is_cell_floor(Vector3(_cell.x, _cell.y - 1, _cell.z))


func is_hovered_cell_empty() -> bool:
	# GridMap.get_cell_item() returns the index of the tile at the specified
	# coordinates.
	return _gridmap.get_cell_item(_cell.x, _cell.y, _cell.z) == EMPTY_CELL_INDEX


func is_cell_floor(cell: Vector3) -> bool:
	return _gridmap.get_cell_item(cell.x, cell.y, cell.z) in FLOOR_CELL_IDS


func _update_preview_mesh() -> void:
	_preview.mesh = MESH_LIBRARY.get_item_mesh(BUILDING_OPTIONS[_building_index])


func _update_preview() -> void:
	var result := _cast_ray_from_mouse()
	if result.empty():
		_preview.hide()
	else:
		# This converts the position the ray hit into grid coordinates.
		_cell = _gridmap.world_to_map(result.position)

		# We turn the preview green if the player can build. Otherwise, we make
		# it red.
		var color: Color = VALID_CELL_COLOR if can_build_in_hovered_cell() else INVALID_CELL_COLOR
		_preview.material_override.albedo_color = color

		# We convert the grid coordinates back to world coordinates to snap the
		# preview to the center of the cell.
		_preview.global_transform.origin = _gridmap.map_to_world(_cell.x, _cell.y, _cell.z)
		_preview.show()


func _cast_ray_from_mouse() -> Dictionary:
	var mouse_position := get_viewport().get_mouse_position()
	# This method projects screen coordinates to where the camera node is in the
	# 3D world.
	var from: Vector3 = _camera.project_ray_origin(mouse_position)
	# And this one projects the position from the camera into the world.
	# You want to multiply the result for the ray to be long enough to ensure
	# it'll hit the ground.
	var to: Vector3 = from + _camera.project_ray_normal(mouse_position) * 1000
	# This PhysicsDirectSpaceState object gives us a door into the world's
	# physics.
	var space_state := get_world().direct_space_state
	# With it, we can do raycast checks and much more.
	return space_state.intersect_ray(from, to, [self])


func _set_building_index(new_index: int) -> void:
	_building_index = wrapi(new_index, 0, BUILDING_OPTIONS.size())
	_update_preview_mesh()
