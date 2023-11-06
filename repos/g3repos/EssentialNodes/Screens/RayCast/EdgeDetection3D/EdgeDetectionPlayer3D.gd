extends KinematicBody

export (NodePath) var camera_controller_path: NodePath

export var move_speed := 6.0
export var acceleration := 4.0
export var rotation_speed := 12.0
export var snap_length := 0.5
export var do_stop_on_slope := true
export var has_infinite_inertia := true

var _move_direction := Vector3.ZERO
var _last_strong_direction := Vector3.FORWARD
var _velocity: Vector3
var _snap := Vector3.DOWN * snap_length
var _gravity: float = -16.0

onready var _camera_controller: Spatial = get_node(camera_controller_path)
onready var _model: Spatial = $AstronautSkin
onready var _start_position := global_transform.origin
onready var _raycast: RayCast = $AstronautSkin/RayCast


func _ready() -> void:
	_model.max_ground_speed = move_speed


func _physics_process(delta: float) -> void:
	_move_direction = _get_camera_oriented_input()

	# To not orient quickly to the last input, we save a last strong direction,
	# this also ensures a good normalized value for the rotation basis.
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()

	_orient_character_to_direction(_last_strong_direction, delta)
	# We separate out the y velocity to not interpolate on the gravity
	var y_velocity = _velocity.y
	_velocity.y = 0.0
	
	_velocity = _velocity.linear_interpolate(_move_direction * move_speed, acceleration * delta)
	if not _raycast.is_colliding():
		_velocity = Vector3.ZERO
	_velocity.y = y_velocity

	if is_on_floor():
		_velocity.y = 0.0
	else:
		_velocity.y += _gravity * delta
	_velocity = move_and_slide_with_snap(
		_velocity, _snap, Vector3.UP, do_stop_on_slope, 4, deg2rad(45), has_infinite_inertia
	)
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
	var raw_input = Vector2(input_left_right, input_forward_back)

	var input := Vector3.ZERO
	# This is to ensure that diagonal input isn't stronger than axis aligned input
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input = _camera_controller.global_transform.basis.xform(input)
	return input


func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction).get_rotation_quat()
	var model_scale := _model.transform.basis.get_scale()
	_model.transform.basis = Basis(_model.transform.basis.get_rotation_quat().slerp(rotation_basis, delta * rotation_speed)).scaled(
		model_scale
	)


func reset_position() -> void:
	transform.origin = _start_position
