extends Spatial

onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		toggle_flashlight()


func toggle_flashlight() -> void:
	_animation_player.play(
		"turn_on" if _animation_player.assigned_animation == "turn_off" else "turn_off"
	)
