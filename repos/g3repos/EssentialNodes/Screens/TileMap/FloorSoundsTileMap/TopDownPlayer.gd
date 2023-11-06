class_name TopDownPlayer
extends KinematicBody2D

export var speed := 500.0
export var drag := 4.0

var velocity := Vector2.ZERO


func _physics_process(_delta: float) -> void:
	var direction := Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()

	var desired_velocity := direction * speed
	var steering := desired_velocity - velocity
	velocity += steering / drag
	velocity = velocity.clamped(speed)

	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI / 4, false)
