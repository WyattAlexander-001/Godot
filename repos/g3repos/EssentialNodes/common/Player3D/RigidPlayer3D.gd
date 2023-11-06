class_name RigidPlayer3D
extends RigidBody

export (NodePath) var camera_controller_path: NodePath

## How fast the player moves on the ground.
export var move_speed := 20.0
## Strength of the impulse applied upwards for the player's jump.
export var jump_initial_impulse := 10.0
## Strength of the force applied upwards when the player holds the jump button down.
export var jump_additional_force := 5.0
## How fast the player can turn around to match a new direction.
export var rotation_speed := 12.0

var _move_direction := Vector3.ZERO
var _last_strong_direction := Vector3.FORWARD
var _should_reset := false

onready var _camera_controller: Spatial = get_node(camera_controller_path)
onready var _model: Spatial = $AstronautSkin
onready var _start_position := global_transform.origin
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_model.max_ground_speed = move_speed / 8.0


func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	if _should_reset:
		state.transform.origin = _start_position
		_should_reset = false

	_move_direction = _get_camera_oriented_input()

	# To not orient quickly to the last input, we save a last strong direction,
	# this also ensures a good normalized value for the rotation basis.
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()

	_orient_character_to_direction(_last_strong_direction, state.step)

	if is_jumping(state):
		_model.jump()
		apply_central_impulse(Vector3.UP * jump_initial_impulse)
	elif is_air_boosting(state):
		add_central_force(Vector3.UP * jump_additional_force)

	add_central_force(_move_direction * move_speed)
	_model.velocity = state.linear_velocity


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
	# This ensures correct analogue input strength in any direction with a joypad stick
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


func take_damage() -> void:
	start_blink(false)


func is_jumping(state: PhysicsDirectBodyState) -> bool:
	return Input.is_action_just_pressed("jump_3d") and is_on_floor(state)


## Checks if the player is holding the jump button down while ascending. Gives them a vertical boost.
func is_air_boosting(state: PhysicsDirectBodyState) -> bool:
	return (
		Input.is_action_pressed("jump_3d")
		and not is_on_floor(state)
		and linear_velocity.y > 0.0
	)


func reset_position() -> void:
	_should_reset = true


func start_blink(loop := false) -> void:
	_animation_player.get_animation("blink").set_loop(loop)
	_animation_player.play("blink")


func stop_blink() -> void:
	_animation_player.stop(true)


func is_on_floor(state: PhysicsDirectBodyState) -> bool:
	# Contacts_reported needs to be high enough to count all surfaces on body
	for contact in state.get_contact_count():
		var contact_normal = state.get_contact_local_normal(contact)
		# If the contact is below us we are on the floor
		if contact_normal.dot(Vector3.UP) > 0.5:
			return true
	return false
