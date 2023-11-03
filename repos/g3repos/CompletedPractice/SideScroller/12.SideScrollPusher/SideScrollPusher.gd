extends KinematicBody2D

export var speed := 600.0
export var gravity := 4500.0

var jump_strengths := [1400.0, 1000.0]
var extra_jumps := jump_strengths.size()
var jump_number := 0
var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta

	var is_jumping := Input.is_action_just_pressed("jump")
	var is_jump_cancelled := Input.is_action_just_released("jump") and velocity.y < 0.0
	if is_jumping and jump_number < extra_jumps:
		velocity.y = -jump_strengths[jump_number]
		jump_number += 1
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_on_floor():
		jump_number = 0
	
	# The third, fourth, and fifth arguments control movement on slopes and
	# curved terrain.
	#
	# The last argument prevents the body from pushing RigidBody2D nodes
	# automatically.
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI / 4, false)

	# Loop over all collisions that occurred in this frame
	for index in get_slide_count():
		var collision := get_slide_collision(index)
		# Check if we collided with a RigidBody2D.
		if collision.collider is RigidBody2D:
			# Push the rock from the center.
			var impulse := -collision.normal * 5000 * delta
			collision.collider.apply_central_impulse(impulse)
