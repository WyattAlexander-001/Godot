extends "res://common/PlayerSideScroll/PlayerSideScroll.gd"

onready var _collision_area: Area2D = $Area2D

onready var _health_bar: ProgressBar = $CanvasLayer/MarginContainer/VBoxContainer/ProgressBar
onready var _health_tween: Tween = $CanvasLayer/MarginContainer/VBoxContainer/ProgressBar/Tween


func _ready() -> void:
	_collision_area.connect("area_entered", self, "_on_Area2D_area_entered")
	_collision_area.connect("body_entered", self, "_on_Area2D_body_entered")


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area is HealthKit:
		if _health_bar.value != _health_bar.max_value:
			heal(area.health_given)
			area.pickup()


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Projectile:
		take_damage(body.damage)
		body.destroy()

func heal(amount: int) -> void:
	_health_tween.interpolate_property(
		_health_bar,
		"value",
		_health_bar.value,
		_health_bar.value + amount,
		0.5,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	_health_tween.start()

func take_damage(amount: int) -> void:
	_health_tween.interpolate_property(
		_health_bar,
		"value",
		_health_bar.value,
		_health_bar.value - amount,
		0.5,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	_health_tween.start()
	yield(_health_tween, "tween_all_completed")
	if _health_bar.value == 0:
		die()


func die() -> void:
	queue_free()
