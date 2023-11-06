extends Spatial

onready var _animation_player: AnimationPlayer = $Player/AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_3d"):
		_animation_player.stop(true)
		_animation_player.play("shoot")
