extends Spatial

onready var _billboard := $Sign/Billboard
onready var _tween := $Sign/Tween
onready var _sign := $Sign


func _ready() -> void:
	_billboard.hide()
	_sign.connect("body_entered", self, "_on_Area_body_entered")
	_sign.connect("body_exited", self, "_on_Area_body_exited")


func _show_message() -> void:
	_tween.interpolate_property(
		_billboard, "scale", Vector3.ZERO, Vector3.ONE, 0.2, Tween.TRANS_CUBIC
	)
	_tween.start()
	_billboard.show()


func _hide_message() -> void:
	_tween.interpolate_property(_billboard, "scale", Vector3.ONE, Vector3.ZERO, 0.3, Tween.EASE_IN)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_billboard.hide()

func _on_Area_body_entered(_body: Node) -> void:
	_show_message()


func _on_Area_body_exited(_body: Node) -> void:
	_hide_message()
