extends Button

onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _pressed() -> void:
	_animation_player.stop()
	_animation_player.play("pressed")
