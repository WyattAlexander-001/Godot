extends KinematicBody2D

const SPEED := 1000.0
var velocity := Vector2()


func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func _physics_process(_delta: float) -> void:
	var direction := Vector2()
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide(velocity)

