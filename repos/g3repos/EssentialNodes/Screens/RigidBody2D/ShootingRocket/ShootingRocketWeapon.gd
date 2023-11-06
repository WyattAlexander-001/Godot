extends Node2D

export var rocket_scene: PackedScene

onready var _timer := $Timer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		fire_rocket(global_rotation)


func fire_rocket(rocket_direction: float) -> void:
	if not _timer.is_stopped():
		return

	_timer.start()

	var rocket = rocket_scene.instance()

	rocket.rocket_direction = Vector2.UP.rotated(rocket_direction)
	rocket.position = global_position
	add_child(rocket)
