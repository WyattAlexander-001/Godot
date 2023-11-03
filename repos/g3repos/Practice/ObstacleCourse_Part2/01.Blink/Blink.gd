extends Node2D

onready var animation_player := $AnimationPlayer
onready var button := $Button

func _ready() -> void:
	# The button emits the "toggled" signal every time you click it.
	button.connect("toggled", self, "_on_button_toggled")


# If the button is pressed down, the is_on argument will be true.
# If the button is released, the is_on arguments will be false.
func _on_button_toggled(is_on: bool) -> void:
	# If the button is toggled, play the blink animation, otherwise,
	# stop the animation player.
	# To stop the animation, call the animation_player.stop() function.
	pass
