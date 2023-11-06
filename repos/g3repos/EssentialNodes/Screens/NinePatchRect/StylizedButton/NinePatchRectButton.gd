## A NinePatchRect that responds like a button.
extends NinePatchRect

# Signals based on Button's signals. You can connect them to other scripts too.
signal pressed()
signal button_down()
signal button_up()

# AnimationPlayer to make the button grow and rotate when pressed.
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			_on_button_down()
		else:
			_on_button_up()
			_on_pressed()


func _on_button_down() -> void:
	self.modulate = Color(0.6, 0.6, 0.6)
	emit_signal("button_down")


func _on_button_up() -> void:
	self.modulate = Color(1.3, 1.3, 1.3)
	emit_signal("button_up")


func _on_mouse_entered() -> void:
	self.modulate = Color(1.3, 1.3, 1.3)


func _on_mouse_exited() -> void:
	self.modulate = Color.white


func _on_pressed() -> void:
	_animation_player.stop()
	_animation_player.play("pressed")
	emit_signal("pressed")
