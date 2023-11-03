extends KinematicBody2D

export var max_speed := 450.0
export var drag_factor := 0.1

var velocity := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var direction := Vector2.UP
	var relative_cursor_position := get_local_mouse_position()
	if relative_cursor_position.length() < 500:
		direction = relative_cursor_position.normalized()
	desired_velocity = max_speed * direction
	steering_vector = desired_velocity - velocity
	velocity += steering_vector * drag_factor
	velocity = move_and_slide(velocity, Vector2.DOWN)
