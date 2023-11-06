extends Spatial

export(NodePath) var player_path: NodePath
export(float, 0.0, 1.0) var mouse_sensitivity := 0.25
export(float, 0.0, 8.0) var joystick_sensitivity := 2.0
export(float, -90, 0.0) var tilt_upper_limit := -60.0
export(float, 0.0, 90.0) var tilt_lower_limit := 60.0
export(float, 2.0, 20.0) var camera_speed := 10.0

var target_transform := Transform()

var _rotation_input: float
var _tilt_input: float
var _mouse_input := false
var _camera_offset: Vector3

onready var _player: Spatial = get_node(player_path)
onready var _tilt_pivot: Spatial = get_node("CameraTiltPivot")

onready var _camera_collision: KinematicBody = $CameraCollision
onready var _camera_parent: Spatial = $CameraTiltPivot/SpringArm/CameraOriginalPosition


func _ready() -> void:
	_camera_offset = global_transform.origin - _player.global_transform.origin


func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = (
		event is InputEventMouseMotion
		and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if _mouse_input:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity


func _physics_process(delta: float) -> void:
	var camera_target: Transform = (
		target_transform
		if _camera_collision.is_set_as_toplevel()
		else _camera_parent.global_transform
	)
	_camera_collision.global_transform = interpolate_rotation(
		_camera_collision.global_transform, camera_target, 2.0 * delta
	)
	var camera_direction = _camera_collision.global_transform.origin.direction_to(
		camera_target.origin
	)
	global_transform.origin = _player.global_transform.origin + _camera_offset
	if _camera_collision.global_transform.origin.distance_to(camera_target.origin) > 0.4:
		_camera_collision.move_and_slide(camera_speed * camera_direction, Vector3.UP)
	_rotation_input += (
		Input.get_action_strength("camera_left")
		- Input.get_action_strength("camera_right")
	)
	_tilt_input += Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down")

	if not _mouse_input:
		_rotation_input *= joystick_sensitivity
		_tilt_input *= joystick_sensitivity

	rotate_y(_rotation_input * delta)
	_tilt_pivot.rotate_x(_tilt_input * delta)
	_tilt_pivot.rotation_degrees.x = clamp(
		_tilt_pivot.rotation_degrees.x, tilt_upper_limit, tilt_lower_limit
	)

	_rotation_input = 0.0
	_tilt_input = 0.0


func reset_camera_position():
	global_transform.origin = _player.global_transform.origin + _camera_offset
	_camera_collision.global_transform = _camera_parent.global_transform


func set_focus_to(target_global_transform: Transform) -> void:
	_camera_collision.set_as_toplevel(true)
	target_transform = target_global_transform


func reset_focus() -> void:
	_camera_collision.set_as_toplevel(false)


## Smoothly interpolates between two transforms' rotations using quaternions.
func interpolate_rotation(from: Transform, to: Transform, weight: float) -> Transform:
	# Using quaternions makes interpolation smoother and prevents Gimbal lock.
	var start_rotation := from.basis.get_rotation_quat()
	var target_rotation := to.basis.get_rotation_quat()
	return Transform(start_rotation.slerp(target_rotation, weight), from.origin)


func get_camera_global_transform() -> Transform:
	return _camera_collision.global_transform
