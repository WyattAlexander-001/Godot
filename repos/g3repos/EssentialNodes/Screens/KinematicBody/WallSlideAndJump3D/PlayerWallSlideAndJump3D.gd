extends BasePlayerPlatformer3D

export var wall_friction_multiplier := 0.5

var _wall_normal: Vector3
var _input_direction: Vector3
var _wall_input: Vector3
var _is_locked_to_wall := false

onready var _wall_jump_timer: Timer = $WallJumpTimer

func _physics_process(delta: float) -> void:
	_input_direction = _get_camera_oriented_input()

	if _wall_jump_timer.is_stopped():
		_move_direction = _input_direction
	else:
		_move_direction = lerp(
			_input_direction, _wall_input, _wall_jump_timer.time_left / _wall_jump_timer.wait_time
		)

	# To not orient quickly to the last input, we save a last strong direction,
	# this also ensures a good normalized value for the rotation basis.
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()

	_orient_character_to_direction(_last_strong_direction, delta)

	_wall_normal = get_wall_normal()

	if _is_locked_to_wall:
		_is_locked_to_wall = not is_pressing_away_from_wall()
	else:
		_is_locked_to_wall = is_on_wall() and is_pressing_against_wall()

	if is_wall_sliding():
		# We apply some friction to slow down the character's fall.
		_velocity *= wall_friction_multiplier
		# And we push the character towards the wall to make them stick to it.
		_velocity += _wall_normal * _gravity * delta

	# We separate out the y velocity to not interpolate on the gravity
	var y_velocity = _velocity.y
	_velocity.y = 0.0
	_velocity = _velocity.linear_interpolate(_move_direction * move_speed, acceleration * delta)
	_velocity.y = y_velocity

	if is_on_floor():
		_velocity.y = 0.0
	else:
		_velocity.y += _gravity * delta

	if is_jumping():
		_velocity.y = jump_initial_impulse
		_snap = Vector3.ZERO
		_model.jump()
	elif is_wall_jumping():
		_wall_jump_timer.start()
		_velocity.y = jump_initial_impulse
		_wall_input = _wall_normal
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
	_model.velocity = _velocity


func get_wall_normal() -> Vector3:
	if not is_on_wall():
		return _wall_normal
	return get_slide_collision(0).normal

## Returns `true` if the character is initiating a wall-jump.
func is_wall_jumping() -> bool:
	return not is_on_floor() and Input.is_action_just_pressed("jump_3d") and _is_locked_to_wall


## Returns `true` if the character is sliding against a wall.
func is_wall_sliding() -> bool:
	return is_on_wall() and not is_on_floor() and _velocity.y < 0.0 and _is_locked_to_wall


# Returns `true` if player input is towards wall while next to it.
func is_pressing_against_wall() -> bool:
	return _move_direction.normalized().dot(_wall_normal) < -0.5


# Returns `true` if the player input is away from the wall they are next to.
func is_pressing_away_from_wall() -> bool:
	return _move_direction.length() > 0.1 and _move_direction.normalized().dot(_wall_normal) > -0.5
