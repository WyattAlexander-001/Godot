extends RigidBody2D

var direction := Vector2.ZERO

onready var _tween := $Tween
onready var _trail := $Trail


func _ready() -> void:
	set_as_toplevel(true)
	linear_velocity = 1500 * direction
	look_at(direction)


func _on_Timer_timeout() -> void:
	_trail.emitting = false
	_tween.interpolate_property(self, "modulate", modulate, Color.transparent, 1)
	_tween.start()
	yield(_tween, "tween_all_completed")
	queue_free()
