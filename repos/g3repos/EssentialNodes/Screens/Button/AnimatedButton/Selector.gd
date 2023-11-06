extends Sprite

signal pressed_animation_finished

export var menu_button_group: ButtonGroup
onready var tween: Tween = $Tween


func _ready() -> void:
	var buttons := menu_button_group.get_buttons()
	for button in buttons:
		# Allows mouse and keyboard to share selector when selecting buttons
		button.connect("mouse_entered", button, "grab_focus")
		button.connect("focus_entered", self, "move_to_button", [button])
		button.connect("focus_exited", self, "unfocus_button", [button])
		button.connect("pressed", self, "animate_button_press", [button])
	buttons[0].grab_focus()


func move_to_button(button: Button) -> void:
	tween.stop(self, "position")
	tween.interpolate_property(
		self,
		"position",
		position,
		button.rect_global_position,
		0.15,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		button,
		"rect_scale",
		button.rect_scale,
		Vector2.ONE * 1.1,
		0.3,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	tween.start()




func unfocus_button(button: Button) -> void:
	tween.interpolate_property(
		button,
		"rect_scale",
		button.rect_scale,
		Vector2.ONE,
		0.3,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	if not tween.is_active():
		tween.start()


func animate_button_press(button: Button) -> void:
	tween.stop(self, "offset")
	tween.interpolate_property(
		self, "offset", Vector2(0, 57), Vector2(-128, 57), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	tween.interpolate_property(
		button, "rect_scale", button.rect_scale, Vector2.ZERO, 0.5, Tween.TRANS_ELASTIC
	)
	tween.interpolate_property(
		button, "rect_rotation", 30, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	emit_signal("pressed_animation_finished")
	# We use a delay to reset the scale after the above animations finished
	tween.interpolate_property(
		button,
		"rect_scale",
		Vector2.ZERO,
		Vector2.ONE,
		0.3,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT,
		0.75
	)
	tween.start()
