extends Control

onready var _boost_icon := $BoostCooldown
onready var _tween := $Tween
onready var _animator := $AnimationPlayer
onready var _label := $Label
onready var _outline := $BoostCooldown/Outline


func refresh_icon() -> void:
	_label.visible = true
	_tween.interpolate_property(_boost_icon, "rect_scale", Vector2.ONE * 1.5, Vector2.ONE, 0.5)
	_tween.start()


func animate_cooldown(duration: float) -> void:
	_animator.play("activate")
	_tween.interpolate_property(_boost_icon, "tint_progress", Color.black, Color.white, duration)
	_tween.interpolate_property(_boost_icon, "value", 0, 100, duration)
	_tween.start()
