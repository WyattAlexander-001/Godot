extends Position2D

export var max_spawn_count := 9
export var enemy_scene: PackedScene

var _player_reference: Player

onready var _enemy_container := $Enemies


func _ready():
	# We make a safety check in case the node group isn't properly set.
	var player_group_nodes := get_tree().get_nodes_in_group("SpawnRoomPlayer")
	if player_group_nodes:
		_player_reference = player_group_nodes[0] as Player


func spawn_enemy() -> void:
	if _enemy_container.get_child_count() >= max_spawn_count or not _player_reference:
		return

	var enemy = enemy_scene.instance()
	_enemy_container.add_child(enemy)
	enemy.player_reference = _player_reference


func _on_Timer_timeout() -> void:
	spawn_enemy()
