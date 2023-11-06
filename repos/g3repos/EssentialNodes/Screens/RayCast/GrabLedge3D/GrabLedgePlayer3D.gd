extends KinematicBody

export var move_speed := 6.0
export var ledge_move_speed := 3.0

export var acceleration := 6.0
export var jump_initial_impulse := 12.0
export var rotation_speed := 12.0
export var snap_length := 0.5
export var do_stop_on_slope := true
export var has_infinite_inertia := true

var _move_direction := Vector3.ZERO
var _last_strong_direction := Vector3.FORWARD
var _velocity: Vector3
var _snap := Vector3.DOWN * snap_length
var _gravity: float = -30.0

onready var _camera_controller: Spatial = $ThirdPersonCamera
onready var _pivot: Spatial = $Pivot
onready var _start_position := global_transform.origin
onready var _body_raycast: RayCast = $Pivot/BodyRayCast
onready var _reach_raycast: RayCast = $Pivot/ReachRayCast
onready var _ledge_timer: Timer = $LedgeTimer
onready var _model: AstronautSkin = $Pivot/AstronautSkin


func _ready() -> void:
	_model.max_ground_speed = move_speed
	_model.max_ledge_speed = ledge_move_speed
	_model.connect("mantle_finished", self, "_finish_mantle")


func _physics_process(delta: float) -> void:
	_model.is_on_ledge = is_ledge_hanging()
	if is_ledge_hanging():
		_move_direction = _calculate_ledge_oriented_input()
		update_last_strong_direction()
		var wall_direction = -_body_raycast.get_collision_normal()
		_orient_character_to_direction(wall_direction, delta)
	else:
		_move_direction = _get_camera_oriented_input()
		update_last_strong_direction()
		_orient_character_to_direction(_last_strong_direction, delta)

	# We separate out the y velocity to not interpolate on the gravity
	var y_velocity := _velocity.y
	_velocity.y = 0.0
	var speed := ledge_move_speed if is_ledge_hanging() else move_speed
	_velocity = _velocity.linear_interpolate(_move_direction * speed, acceleration * delta)
	_velocity.y = y_velocity
	if is_on_floor() or is_ledge_hanging():
		_velocity.y = 0.0
	else:
		_velocity.y += _gravity * delta
	if is_jumping():
		_velocity.y = jump_initial_impulse
		_snap = Vector3.ZERO
		_model.jump()
	elif is_landing():
		_model.land()
		_snap = Vector3.DOWN * snap_length

	if is_mantling():
		_model.mantle()
		set_physics_process(false)
		return

	if is_exiting_ledge_hang() or is_mantling():
		_ledge_timer.start()

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

func _calculate_ledge_oriented_input() -> Vector3:
	var input_left_right := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	_model.move_horizontal_direction = input_left_right
	var input := _body_raycast.get_collision_normal().cross(Vector3.DOWN) * input_left_right
	input -= _body_raycast.get_collision_normal()
	return input

func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction).orthonormalized()
	_pivot.transform.basis = _pivot.transform.basis.slerp(rotation_basis, delta * rotation_speed)


# Called by mantle animation in AnimationPlayer
func _finish_mantle() -> void:
	global_transform.origin = _model.global_transform.origin
	_model.transform.origin = Vector3.ZERO
	_velocity = Vector3.ZERO
	set_physics_process(true)


func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump_3d") and is_on_floor()


func is_landing() -> bool:
	return _snap == Vector3.ZERO and is_on_floor()

func is_ledge_hanging() -> bool:
	return (
		not is_on_floor()
		and _body_raycast.is_colliding()
		and not _reach_raycast.is_colliding()
		and _ledge_timer.is_stopped()
	)

func is_exiting_ledge_hang() -> bool:
	return is_ledge_hanging() and Input.get_action_strength("move_down") > 0.5


func is_mantling() -> bool:
	return is_ledge_hanging() and Input.is_action_just_pressed("jump_3d")


func reset_position() -> void:
	transform.origin = _start_position


func update_last_strong_direction() -> void:
	# To not orient quickly to the last input, we save a last strong direction,
	# this also ensures a good normalized value for the rotation basis.
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()
