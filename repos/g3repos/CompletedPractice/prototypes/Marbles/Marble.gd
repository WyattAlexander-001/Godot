# This example shows drawing and interacting with a node.
# The Rigidbody needs to be in rigidbody mode for bounces to work.
# If it can't rotate (character mode), it'll only bounce moving horizontally or vertically.
extends Node2D

var pull_line := Vector2.ZERO


func _process(_delta: float) -> void:
	if Input.is_action_pressed("click"):
		pull_line = get_global_mouse_position() - global_position 
	elif Input.is_action_just_released("click"):
		var impulse := -pull_line * 4
		$RigidBody2D.linear_velocity = impulse
		pull_line = Vector2.ZERO

	update()


func _draw() -> void:
	if pull_line != Vector2.ZERO:
		draw_line($RigidBody2D.position, pull_line, Color.white, 4)
