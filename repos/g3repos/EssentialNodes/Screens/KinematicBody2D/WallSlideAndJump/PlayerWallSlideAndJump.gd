extends BasePlayerSideScroll

export var wall_jump_strength := 2400.0
export var wall_friction_multiplier := 0.5


## When this timer is active, the player can jump even if not on the floor or a wall.
onready var _coyote_timer: Timer = $CoyoteTimer


func _physics_process(delta: float) -> void:
	_horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	_velocity.x = _horizontal_direction * speed
	_velocity.y += gravity * delta
	
	# When the character is on a wall, we push them in the wall's direction to
	# make them stick to it.
	#
	# We also use the variable to jump away from the wall.
	var wall_direction := 0.0

	# The character slides as long as you're on the wall and keep the direction 
	# key towards the wall.
	if is_wall_sliding():
		wall_direction = sign(_horizontal_direction)
		# We apply some friction to slow down the character's fall.
		_velocity *= wall_friction_multiplier
		# And we push the character towards the wall to make them stick to it.
		_velocity.x += wall_direction * gravity * delta
		_coyote_timer.stop()

	# When the character starts falling, we start the coyote timer, allowing the
	# player to jump once mid-air.
	#
	# When jumping or landing, we stop the timer.
	if is_jumping() or is_wall_jumping():
		_velocity.y = -jump_strength
		_snap_vector = Vector2.ZERO
		# When we jump, whether we used our coyote time or not, we don't want to
		# allow for another jump so we stop the timer.
		_coyote_timer.stop()
	elif is_jump_cancelled():
		_velocity.y = 0.0
	elif is_landing():
		_snap_vector = SNAP_DIRECTION * SNAP_VECTOR_LENGTH
		# When landing, we reset the coyote time properties to re-enable them
		# next time we fall.
		_coyote_timer.stop()
	# To allow jumping at the start of a fall, we start our timer. As long as it
	# is running and the player has not jumped yet, we allow them to jump once.
	elif is_just_falling() and is_on_wall() or is_on_floor():
		_coyote_timer.start()

	if is_wall_jumping():
		_velocity.x = -wall_jump_strength * wall_direction

	_velocity.y = move_and_slide_with_snap(
		_velocity, _snap_vector, UP_DIRECTION, do_stop_on_slope, MAX_SLIDES, MAX_SLOPE_ANGLE
	).y
	update_look_direction()
	update_animation()


# This function replaces the parent class's to play the `wall_slide` animation.
func update_animation() -> void:
	if is_jumping() or is_wall_jumping():
		_anim_player.play("jump")
	elif is_running():
		_anim_player.play("run")
	elif is_wall_sliding():
		_pivot.scale.x = -sign(_horizontal_direction) * _start_scale.x
		_anim_player.play("wall_slide")
	elif is_falling():
		_anim_player.play("fall")
	else:
		_anim_player.play("idle")


# We override the parent class's `is_jumping()` to take the coyote timer into
# account.
func is_jumping() -> bool:
	return (
		Input.is_action_just_pressed("jump")
		and (is_on_floor() or not _coyote_timer.is_stopped())
	)


## Returns `true` if the character starts falling.
func is_just_falling() -> bool:
	return not _anim_player.current_animation == "fall" and is_falling()


## Returns `true` if the character is initiating a wall-jump.
func is_wall_jumping() -> bool:
	return is_on_wall() and Input.is_action_just_pressed("jump")


## Returns `true` if the character is sliding against a wall.
func is_wall_sliding() -> bool:
	return is_on_wall() and not is_zero_approx(_horizontal_direction)
