extends PanelContainer

enum Types { ERROR }

onready var _message := $Message as Label
onready var _tween := $Tween as Tween

func setup(message: String, type := 0) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	_message.text = message
	_tween.stop_all()
	_tween.interpolate_property(self, "self_modulate:a", 1.0, 0.25, 1.5)
	_tween.start()
