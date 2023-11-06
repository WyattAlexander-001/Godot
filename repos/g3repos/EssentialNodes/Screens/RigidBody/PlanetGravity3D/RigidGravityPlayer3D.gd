extends RigidBody

export var camera_path: NodePath
## How fast the player moves on the ground.
export var move_speed := 80.0
## Strength of the impulse applied upwards for the player's jump.
export var jump_initial_impulse := 20.0
## How fast the player can turn around to match a new direction.
export var rotation_speed := 8.0

var _move_direction := Vector3.ZERO
var _last_strong_direction := Vector3.FORWARD
var local_gravity := Vector3.DOWN
var _should_reset := false

onready var _camera_controller = get_node(camera_path)
onready var _model: Spatial = $AstronautSkin
onready var _start_position := global_transform.origin


func _ready() -> void:
	_model.max_ground_speed = 4.0


func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	# This clause handles if a player falls off a planet, resetting 
	# their position if they hit the safety net.
	if _should_reset:
		state.transform.origin = _start_position
		_should_reset = false

	local_gravity = state.total_gravity.normalized()


	# To not orient quickly to the last input, we save a last strong direction,
	# this also ensures a good normalized value for the rotation basis.
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()
	
	_move_direction = _get_model_oriented_input()
	_orient_character_to_direction(_last_strong_direction, state.step)
	
	if is_jumping(state):
		_model.jump()
		apply_central_impulse(-local_gravity * jump_initial_impulse)
	if is_on_floor(state) and not _model.is_falling():
		add_central_force(_move_direction * move_speed)
	_model.velocity = state.linear_velocity


func _get_model_oriented_input() -> Vector3:
	var input_left_right := (
		Input.get_action_strength("move_left")
		- Input.get_action_strength("move_right")
	)
	var input_forward := Input.get_action_strength("move_up")

	var raw_input = Vector2(input_left_right, input_forward)

	var input := Vector3.ZERO
	# This ensures correct analogue input strength in any direction with a joypad stick
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input = _model.transform.basis.xform(input)
	return input


func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := -local_gravity.cross(direction)
	var rotation_basis := Basis(left_axis, -local_gravity, direction).orthonormalized()
	_model.transform.basis = _model.transform.basis.get_rotation_quat().slerp(
		rotation_basis, delta * rotation_speed
	)


func is_jumping(state: PhysicsDirectBodyState) -> bool:
	return Input.is_action_just_pressed("jump_3d") and is_on_floor(state)


func reset_position() -> void:
	_should_reset = true


func is_on_floor(state: PhysicsDirectBodyState) -> bool:
	# Contacts_reported needs to be high enough to count all surfaces on body
	for contact in state.get_contact_count():
		var contact_normal = state.get_contact_local_normal(contact)
		# If the contact is below us we are on the floor
		if contact_normal.dot(-local_gravity) > 0.5:
			return true
	return false
