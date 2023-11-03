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
	var is_jump_cancelled := Input.is_action_just_released("jump") and velocity.y < 0.0
	if is_jumping and jump_number < jump_strengths.size():
		velocity.y = -jump_strengths[jump_number]
		jump_number += 1
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_on_floor():
		var is_on_jump_pad: bool = get_slide_collision(0).collider.is_in_group("jump_pad")
		if is_on_jump_pad:
			jump_number = 1
		else:
			jump_number = 0

	velocity = move_and_slide(velocity, Vector2.UP)
