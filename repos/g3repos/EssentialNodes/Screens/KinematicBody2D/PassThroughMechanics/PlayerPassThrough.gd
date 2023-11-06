extends BasePlayerSideScroll

## Index of the layer we want to ignore when dashing or falling through the floor.
const PASS_THROUGH_LAYER := 4

# We store a reference to our CollisionShape2D to do collision checks manually.
# See the is_inside_wall() function.
onready var _collision_shape: CollisionShape2D = $CollisionShape2D


func _physics_process(delta: float) -> void:
	_horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	_velocity.x = _horizontal_direction * speed
	_velocity.y += gravity * delta

	# When the player jumps down, we turn off collisions for the platform.
	if Input.is_action_just_pressed("jump") and Input.is_action_pressed("move_down"):
		set_pass_through_walls_and_floor(true)
	# And when we passed through the platform, we reactivate collisions.
	elif is_passing_through_walls() and not is_inside_wall():
		# We use a collision check to ensure the character won't get stuck
		# inside a platform.
		set_pass_through_walls_and_floor(false)
	elif is_jumping():
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

	update_animation()
	update_look_direction()


## If set to `true`, makes the character pass through walls and the floor.
func set_pass_through_walls_and_floor(value: bool) -> void:
	set_collision_mask_bit(PASS_THROUGH_LAYER, not value)


## Returns `true` if the character is currently in pass-through mode.
func is_passing_through_walls() -> bool:
	return get_collision_mask_bit(PASS_THROUGH_LAYER) == false


## Returns `true` if the character is inside the wall or the floor.
func is_inside_wall() -> bool:
	# The query type allows us to make queries directly to the physics engine.
	var query := Physics2DShapeQueryParameters.new()
	# To make a query, we have to provide a collision shape, select the layer to
	# test for intersections, and the shape's transforms.
	query.set_shape(_collision_shape.shape)
	query.transform = _collision_shape.global_transform
	# Collision layers use bit flags: you can represent every combination of the
	# 20 physics layers by a unique integer.
	#
	# The left shift operator `<<` takes the binary value on the left, here a
	# single bit set to 1, and shifts it to the left several times, adding zeros
	# to the right as necessary.
	#
	# Here, it'll shift it 4 times, turning our value into the binary number
	# 10000.
	#
	# This allows us to set the bit corresponding to PASS_THROUGH_LAYER to 1.
	query.collision_layer = 1 << PASS_THROUGH_LAYER
	# We access the 2D physics server through the 2D world's
	# `Physics2DDirectSpaceState` and call its `intersect_shape()` method.
	#
	# The method returns an array of dictionaries, one for each shape we're
	# intersecting with.
	var intersecting_objects: Array = get_world_2d().direct_space_state.intersect_shape(query)
	return intersecting_objects.size() > 0
