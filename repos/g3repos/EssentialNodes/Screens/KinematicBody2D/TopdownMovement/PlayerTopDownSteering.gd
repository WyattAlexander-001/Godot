class_name BasePlayerTopDown
extends KinematicBody2D

## The character's maximum speed in pixels per second.
export var max_speed := 1000.0
## A divider we use to limit the characters acceleration and deceleration.
export var drag := 4.0

var _velocity := Vector2.ZERO

onready var _sprite: Sprite = $Sprite


func _physics_process(delta: float) -> void:
	# We calculate the move direction with support for analog movement using
	# `Input.get_action_strength()`
	#
	# It returns a value between 0.0 and 1.0 depending on how much you orient
	# the joystick in a given direction.
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	# Ensures the vector has a length of 1.0. If we don't do that, when pressing
	# both up and down, the direction vector has a length of 1 on both the X and
	# Y axes, thus a total length of about ~1.4.
	#
	# Without normalizing it, this would cause the character to move faster in
	# diagonal.
	direction = direction.normalized()

	# We first calculate the desired or ideal velocity.
	var desired_velocity = direction * max_speed
	# The steering vector is the difference between the desired and current
	# velocities.
	var steering = desired_velocity - _velocity
	# We add part of the steering to the current velocity to get it closer to
	# `desired_velocity`.
	_velocity += steering / drag
	# And finally, we always ensure the player can't go past the maximum
	# `max_speed`.
	_velocity = _velocity.clamped(max_speed)

	# With that, we can move the character.
	# We can stick to the default properties for most of move_and_slide()'s arguments.
	_velocity = move_and_slide(_velocity)

	rotation = lerp_angle(rotation, _velocity.angle() + PI / 2 - PI / 2, 20.0 * delta)
