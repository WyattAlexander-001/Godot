extends KinematicBody2D

export var max_speed := 450.0
export var drag_factor := 0.1

var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# We start by calculating the bat's movement direction.
	var direction := Vector2.UP
	var relative_cursor_position := get_local_mouse_position()
	# If the distance to the mouse is less than 500 pixels,
	if relative_cursor_position.length() < 500:
		# We convert the mouse's local position into a direction vector by
		# normalizing the position.
		direction = relative_cursor_position.normalized()

	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor

	velocity = move_and_slide(velocity)
