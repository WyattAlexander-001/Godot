extends Sprite

signal animation_finished

export var pulse_interval := 2.0
export var pulse_duration := 2.0
export var pulse_final_scale := Vector2(1.5, 1.5)

onready var _tween := $Tween


func _ready() -> void:
	connect("animation_finished", self, "pulse")
	pulse()


func pulse() -> void:
	if _tween.is_active():
		_tween.stop_all()
	_tween.interpolate_property(
		self,
		"scale",
		scale,
		pulse_final_scale,
		pulse_duration,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_tween.interpolate_property(
		self,
		"scale",
		scale,
		Vector2.ONE,
		pulse_duration,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	_tween.start()
	yield(_tween, "tween_all_completed")
	yield(get_tree().create_timer(pulse_interval), "timeout")
	emit_signal("animation_finished")
