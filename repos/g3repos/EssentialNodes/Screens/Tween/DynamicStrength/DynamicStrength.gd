extends Control

onready var _explosion := $Explosion
onready var _tween := $Tween
onready var _slider := $HSlider

var duration: float = 1.0


func _on_ExplodeButton_pressed() -> void:
	_explosion.rotation = rand_range(0, TAU)
	_tween.interpolate_property(
		_explosion, "scale", Vector2.ZERO, Vector2.ONE * _slider.value, duration
	)
	_tween.interpolate_property(_explosion, "modulate", Color.white, Color.transparent, duration)
	_tween.start()
