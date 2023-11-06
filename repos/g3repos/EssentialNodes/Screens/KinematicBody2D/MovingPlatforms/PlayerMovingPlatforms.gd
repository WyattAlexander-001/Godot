extends BasePlayerSideScroll

func _ready() -> void:
	## If we call move_and_slide() and request to stop on slopes, the character
	## will also stop on moving platforms instead of moving with them.
	##
	## You can distinguish between slopes and moving platforms by getting
	## collision information and checking the collider's velocity.
	do_stop_on_slope = false

func _physics_process(delta: float) -> void:
	update_animation()
	update_look_direction()
	apply_base_movement(delta)


func apply_base_movement(delta: float) -> void:
	_horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	_velocity.x = _horizontal_direction * speed
	# Prevent the character from moving up slopes past the `MAX_SLOPE_ANGLE`.
	#
	# This crude code leads to cases where the character alternates between idle
	# and run animations quickly.
	#
	# To address it, you need a more robust way of staying in the idle state
	# when against a rotating platform. For instance, using a short RayCast2D at
	# their feet.
	if is_on_wall():
		_velocity.x = sign(_horizontal_direction) * 1.0
	_velocity.y += gravity * delta

	if is_jumping():
		_velocity.y = -jump_strength
		_snap_vector = Vector2.ZERO
	elif is_jump_cancelled():
		_velocity.y = 0.0
	elif is_landing():
		_snap_vector = SNAP_DIRECTION * SNAP_VECTOR_LENGTH

	_velocity = move_and_slide_with_snap(
		_velocity,
		_snap_vector,
		UP_DIRECTION,
		do_stop_on_slope,
		MAX_SLIDES,
		MAX_SLOPE_ANGLE,
		has_infinite_inertia
	)
