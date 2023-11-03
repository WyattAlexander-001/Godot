extends TextureButton

const COLOR_START := Color(0.9604, 0.98, 0.98, 0.698039)
const COLOR_HOVER := Color(0.960784, 0.980392, 0.980392)
const COLOR_PRESSED := Color(0.074405, 0.413513, 0.742188)

onready var _tween := $Tween

func _ready() -> void:
	self_modulate = COLOR_START
	connect("pressed", self, "open_gdquest_website")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")


func open_gdquest_website() -> void:
	OS.shell_open("http://gdquest.com/")


func _on_mouse_entered() -> void:
	_tween.stop_all()
	_tween.interpolate_property(self, "self_modulate", self_modulate, COLOR_HOVER, 0.1)
	_tween.start()


func _on_mouse_exited() -> void:
	_tween.stop_all()
	_tween.interpolate_property(self, "self_modulate", self_modulate, COLOR_START, 0.1)
	_tween.start()


func _on_button_down() -> void:
	_tween.stop_all()
	_tween.interpolate_property(self, "self_modulate", self_modulate, COLOR_PRESSED, 0.1)
	_tween.start()


func _on_button_up() -> void:
	_tween.stop_all()
	if get_rect().has_point(get_local_mouse_position()):
		_tween.interpolate_property(self, "self_modulate", self_modulate, COLOR_HOVER, 0.1)
	else:
		_tween.interpolate_property(self, "self_modulate", self_modulate, COLOR_START, 0.1)
	_tween.start()
