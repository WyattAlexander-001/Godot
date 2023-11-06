## Character that can walk around planets and jump from planet to planet.
extends RigidBody2D

const MOVEMENT_FORCE := 8000.0
const GRAVITY_STRENGTH := 5800.0
const JUMP_STRENGTH := 4400.0
const ROTATION_SCALE := 20.0

onready var _character := $Character
onready var _animator := $Character/Skin/AnimationPlayer
onready var _raycast := $RayCast2D


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var local_gravity := state.total_gravity.normalized()
	var local_gravity_tangent := local_gravity.tangent()
	var direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if direction:
		_character.scale.x = sign(direction) * abs(_character.scale.x)
	# Move perpendicular to gravity
	state.apply_central_impulse(local_gravity_tangent * state.step * MOVEMENT_FORCE * direction)
	# Align rotation to gravity
	_character.rotation = lerp_angle(
		_character.rotation, local_gravity_tangent.angle(), state.step * ROTATION_SCALE
	)
	# Jump and apply local gravity
	if Input.is_action_just_pressed("jump") and is_on_floor(local_gravity):
		state.apply_central_impulse(-local_gravity * JUMP_STRENGTH)

	state.apply_central_impulse(state.step * local_gravity * GRAVITY_STRENGTH)
	
	if is_on_floor(local_gravity):
		if direction:
			_animator.play("run")
		else:
			_animator.play("idle")
	else:
		if state.total_gravity.dot(state.linear_velocity) < 0:
			_animator.play("jump")
		else:
			_animator.play("fall")


func is_on_floor(gravity_in: Vector2):
	_raycast.rotation = gravity_in.angle()
	_raycast.force_raycast_update()
	return _raycast.is_colliding()
