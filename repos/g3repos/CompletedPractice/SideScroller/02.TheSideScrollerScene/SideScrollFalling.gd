extends KinematicBody2D

export var speed := 600.0
export var gravity := 4500.0

var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)
