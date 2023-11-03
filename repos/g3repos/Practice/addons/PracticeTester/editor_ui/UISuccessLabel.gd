tool
extends Label

const COLOR_SUCCESS := Color(0.239216, 1, 0.431373)
const COLOR_ERROR := Color(1, 0.094118, 0.321569)

onready var _tween := $Tween as Tween


func _ready() -> void:
	_tween.connect("tween_all_completed", self, "hide")


func display(message: String, is_success := true) -> void:
	show()
	modulate = COLOR_SUCCESS if is_success else COLOR_ERROR
	text = message
	_tween.stop_all()
	_tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.2)
	_tween.interpolate_property(
		self, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 1.5
	)
	_tween.start()
	_tween.seek(0.0)
