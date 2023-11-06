extends Node2D

var _is_open := false

onready var _area := $Area2D
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if _animation_player.is_playing():
		return

	if event.is_action_pressed("interact"):
		for body in _area.get_overlapping_bodies():
			if body is Player:
				toggle_open()
				return


func toggle_open() -> void:
	if _is_open:
		_animation_player.play("close")
	else:
		_animation_player.play("open")
	_is_open = not _is_open
