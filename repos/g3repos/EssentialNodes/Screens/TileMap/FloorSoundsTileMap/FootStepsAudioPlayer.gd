extends AudioStreamPlayer2D

export var tile_map_path: NodePath
export var grass_cell_id := 1
export var concrete_cell_id := 2
export var grass_step_sound: AudioStream
export var concrete_step_sound: AudioStream
export var step_distance := 160.0

var _step_measure := 0.0

onready var _player := get_parent() as KinematicBody2D
onready var _tile_map: TileMap = get_node(tile_map_path) as TileMap
onready var _tile_mad_types = {
	grass_cell_id: grass_step_sound, concrete_cell_id: concrete_step_sound
}


func _physics_process(delta: float) -> void:
	_step_measure += _player.velocity.length() * delta

	if _step_measure > step_distance:
		_step_measure = 0.0
		play_footstep()


func play_footstep() -> void:
	# Find the tile coordinate
	var tile_coordinate = _tile_map.world_to_map(_player.position)
	# Find what cell is in that coordinate
	var cell = _tile_map.get_cell(tile_coordinate.x, tile_coordinate.y)

	# If the _tile_map_types does not contain the grid item type - return
	if not _tile_mad_types.has(cell):
		return

	# Look up the play_footstep sound in directory
	var footstep_sound = _tile_mad_types[cell]

	# Only assign the new sound if it's different from the current, as changing the assigned sound
	# stops it, if it is already playing
	if stream != footstep_sound:
		stream = footstep_sound
	play()
