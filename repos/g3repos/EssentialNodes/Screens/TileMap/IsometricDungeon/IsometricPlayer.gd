## A 2D player that moves stronger with the isometric grid.
extends KinematicBody2D


var velocity := Vector2()

const SPEED := 12000.0
const ISOMETRIC_RATIO := Vector2(1.5, 1.0)


func _physics_process(delta) -> void:
	var input_direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	velocity = ISOMETRIC_RATIO * input_direction * SPEED * delta
	velocity = move_and_slide(velocity)
