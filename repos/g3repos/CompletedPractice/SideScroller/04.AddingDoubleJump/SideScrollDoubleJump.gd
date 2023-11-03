extends KinematicBody2D

export var speed := 600.0
export var gravity := 4500.0
export var jump_strengths := [1400.0, 1000.0]

var jump_number := 0
var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta
	var is_jumping := Input.is_action_just_pressed("jump")
	# Verify if "jump" was released while character is rising.
	var is_jump_cancelled := Input.is_action_just_released("jump") and velocity.y < 0.0
	# If the character is jumping and there are jumps remaining.
	if is_jumping and jump_number < jump_strengths.size():
		# Apply the current jump's strength and increment the jump number.
		velocity.y = -jump_strengths[jump_number]
		jump_number += 1
	elif is_jump_cancelled:
		velocity.y = 0.0
	# While the character is on the floor, restore all jumps.
	elif is_on_floor():
		jump_number = 0
	velocity = move_and_slide(velocity, Vector2.UP)
