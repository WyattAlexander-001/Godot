extends Node2D

export var bomb_scene: PackedScene

onready var _timer := $Timer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		release_bomb()


func release_bomb() -> void:
	if not _timer.is_stopped():
		return
	_timer.start()

	var bomb = bomb_scene.instance()
	bomb.position = global_position
	bomb.rotation = global_rotation
	add_child(bomb)
