extends RigidBody2D

export var movement_force := 5000.0

onready var _body := $Body
onready var _animator := $Body/PlayerSideSkin/AnimationPlayer
onready var _left_ray: RayCast2D = $LeftRayCast2D
onready var _right_ray: RayCast2D = $RightRayCast2D


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var direction := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	apply_central_impulse(Vector2.RIGHT * direction * movement_force * state.step)
	
	if not _left_ray.is_colliding():
		state.linear_velocity.x = max(0.0, state.linear_velocity.x)
	if not _right_ray.is_colliding():
		state.linear_velocity.x = min(0.0, state.linear_velocity.x)

	if direction:
		_animator.play("run")
		_body.scale.x = sign(direction) * abs(_body.scale.x)
	else:
		_animator.play("idle")
