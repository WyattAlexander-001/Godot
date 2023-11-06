extends Control

onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _button: Button = $Button


func _ready() -> void:
	_button.connect("pressed", self, "_on_Button_pressed")


func _on_Button_pressed() -> void:
	# The argument forces the AnimationPlayer to reset the animation.
	_anim_player.stop(true)
	_anim_player.play("scale_windows")
