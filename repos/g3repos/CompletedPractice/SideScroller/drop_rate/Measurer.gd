extends KinematicBody2D

export var gravity := 4500.0

var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)
