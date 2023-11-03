extends KinematicBody2D

export var speed := 600.0
export var gravity := 4500.0
export var jump_strength := 1400.0

var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Get the horizontal direction as a number between -1.0 and 1.0.
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	# Multiply the direction by speed, and assign to the velocity's x value.
	velocity.x = horizontal_direction * speed
	# Add the gravity to the velocity's y value.
	velocity.y += gravity * delta

	# Verify if "jump" was pressed while character is on floor.
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	# Verify if "jump" was released while character is rising.
	var is_jump_cancelled := velocity.y < 0.0 and Input.is_action_just_released("jump")

	# If jumping, subtract jump_strength from velocity.y.
	# But if player cancelled jump instead, set velocity.y to 0.0.
	# Otherwise, leave velocity.y as it is.
	if is_jumping:
		velocity.y = -jump_strength
	elif is_jump_cancelled:
		velocity.y = 0.0

	# Move this kinematic body based on its velocity.
	velocity = move_and_slide(velocity, Vector2.UP)
