extends BasePlayerPlatformer3D

const SNAP_TEXT := "Snap vector: %s"

onready var _label: Label = $CanvasLayer/Label
onready var _snap_options := [Vector3.DOWN * snap_length, Vector3.ZERO]


func _ready() -> void:
	_toggle_snap()


func _physics_process(delta: float) -> void:
	_move_direction = _get_camera_oriented_input()
	if Input.is_action_just_pressed("interact"):
		_toggle_snap()
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
	elif is_on_floor():
		_velocity.y = 0.0
		_snap = _snap_options.front()
	else:
		_velocity.y += _gravity * delta

	_velocity = move_and_slide_with_snap(
		_velocity, _snap, Vector3.UP, do_stop_on_slope, 4, deg2rad(45), has_infinite_inertia
	)
	_model.velocity = _velocity
	
	_label.text = SNAP_TEXT % _snap


func _toggle_snap() -> void:
	_snap_options.push_back(_snap_options.pop_front())
	_snap = _snap_options.front()
