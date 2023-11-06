extends AudioStreamPlayer3D

export var grid_map_path: NodePath
export var grass_cell_ids: PoolIntArray
export var concrete_cell_ids: PoolIntArray
export var grass_step_sound: AudioStream
export var concrete_step_sound: AudioStream
export var step_distance := 2.8

var _step_measure := 0.0
var _grid_map_types = {}

onready var _player: Player3D = get_parent() as Player3D
onready var _grid_map: GridMap = get_node(grid_map_path) as GridMap


func _ready() -> void:
	# generates a dictionary of the grid map types that correspond to each sound
	for id in grass_cell_ids:
		_grid_map_types[id] = grass_step_sound
	for id in concrete_cell_ids:
		_grid_map_types[id] = concrete_step_sound


func footstep() -> void:
	# Find the grid coordinate, we offset by Vector3.DOWN so we find the cell under the player
	var grid_position = _grid_map.to_local(global_transform.origin + Vector3.DOWN)
	var grid_coordinate = _grid_map.world_to_map(grid_position)
	# Find what type of grid item is in that coordinate
	var cell_item = _grid_map.get_cell_item(grid_coordinate.x, grid_coordinate.y, grid_coordinate.z)

	# If the _grid_map_types does not contain the grid item type - return
	if not _grid_map_types.has(cell_item):
		return

	# Look up the footstep sound
	var footstep_sound = _grid_map_types[cell_item]

	# Only assign the new sound if it's different from the current, as changing the assigned sound
	# stops it, if it is already playing
	if stream != footstep_sound:
		stream = footstep_sound
	play()


func _physics_process(delta: float) -> void:
	if _player.is_on_floor():
		_step_measure += _player.velocity.length() * delta

	if _step_measure > step_distance:
		_step_measure = 0.0
		footstep()
