extends Node2D

onready var _text_frame := $Sign/NinePatchRect
onready var _tween := $Sign/Tween
onready var _sign: Area2D = $Sign


func _ready() -> void:
	_text_frame.hide()
	_sign.connect("body_entered", self, "_on_Sign_body_entered")
	_sign.connect("body_exited", self, "_on_Sign_body_exited")


func show_message() -> void:
	_tween.interpolate_property(
		_text_frame, "rect_scale", Vector2.ZERO, Vector2.ONE, 0.2, Tween.TRANS_CUBIC
	)
	_tween.start()
	_text_frame.show()


func hide_message() -> void:
	_tween.interpolate_property(
		_text_frame, "rect_scale", Vector2.ONE, Vector2.ZERO, 0.3, Tween.TRANS_BACK, Tween.EASE_IN
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_text_frame.hide()


func _on_Sign_body_entered(_body: PhysicsBody2D):
	show_message()


func _on_Sign_body_exited(_body: PhysicsBody2D):
	hide_message()
