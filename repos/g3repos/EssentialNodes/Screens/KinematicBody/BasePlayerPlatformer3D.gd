class_name BasePlayerPlatformer3D
extends KinematicBody

export var move_speed := 6.0
export var acceleration := 6.0
export var jump_initial_impulse := 12.0
export var jump_additional_force := 4.5
export var rotation_speed := 12.0
export var snap_length := 0.5
export var do_stop_on_slope := true
export var has_infinite_inertia := true

var _move_direction := Vector3.ZERO
var _last_strong_direction := Vector3.FORWARD
var _velocity: Vector3
var _snap := Vector3.DOWN * snap_length
var _gravity: float = -30.0

onready var _camera_controller := $ThirdPersonCamera
onready var _model := $AstronautSkin

onready var _start_position := global_transform.origin


func _ready() -> void:
	_model.max_ground_speed = move_speed


func apply_base_movement(delta: float) -> void:
	_move_direction = _get_camera_oriented_input()

	# To not orient quickly to the last input, we save a last strong direction,
	# this also ensures a good normalized value for the rotation basis.
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()

	_orient_character_to_direction(_last_strong_direction, delta)

	# We separate out the y velocity to not interpolate on the gravity
	var y_velocity := _velocity.y
	_velocity.y = 0.0
	_velocity = _velocity.linear_interpolate(_move_direction * move_speed, acceleration * delta)
	_velocity.y = y_velocity

	if is_jumping():
		_velocity.y = jump_initial_impulse
		_snap = Vector3.ZERO
		_model.jump()
	elif is_air_boosting():
		_velocity.y += jump_additional_force * delta
	elif is_landing():
		_snap = Vector3.DOWN * snap_length
		_model.land()

	_velocity = move_and_slide_with_snap(
		_velocity, _snap, Vector3.UP, do_stop_on_slope, 4, deg2rad(45), has_infinite_inertia
	)

	if is_on_floor():
		_velocity.y = 0.0
	else:
		_velocity.y += _gravity * delta
	_model.velocity = _velocity

func _get_camera_oriented_input() -> Vector3:
	var input_left_right := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var input_forward_back := (
		Input.get_action_strength("move_down")
		- Input.get_action_strength("move_up")
	)
	var raw_input := Vector2(input_left_right, input_forward_back)

	var input := Vector3.ZERO
	# This is to ensure that diagonal input isn't stronger than axis aligned input
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input = _camera_controller.global_transform.basis.xform(input)
	return input

func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction).orthonormalized()
	_model.transform.basis = _model.transform.basis.orthonormalized().slerp(rotation_basis, delta * rotation_speed).scaled(_model.scale)

func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump_3d") and is_on_floor()


func is_air_boosting() -> bool:
	return Input.is_action_pressed("jump_3d") and not is_on_floor() and _velocity.y > 0.0


func is_landing() -> bool:
	return _snap == Vector3.ZERO and is_on_floor()

func reset_position() -> void:
	transform.origin = _start_position
