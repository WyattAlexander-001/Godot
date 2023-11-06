extends Spatial

export var mouse_sensitivity := 0.25
export var rotation_speed := 1.0
export var tilt_speed := 1.0

export (float, -90, 90.0) var tilt_upper_limit := -60.0
export (float, -90.0, 90.0) var tilt_lower_limit := 60.0

var _yaw_input: float
var _tilt_input: float

onready var _camera_rotation_pivot: Spatial = $CameraRotationPivot


func _unhandled_input(event: InputEvent) -> void:
	# Mouse input
	if (
		event is InputEventMouseMotion
		and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	):
		_yaw_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity
	# Joystick input
	if event is InputEventJoypadMotion:
		_yaw_input += (
			event.get_action_strength("camera_left")
			- event.get_action_strength("camera_right")
		)
		_tilt_input += (
			event.get_action_strength("camera_up")
			- event.get_action_strength("camera_down")
		)


func _physics_process(delta: float) -> void:
	# Camera rotation
	rotate_y(_yaw_input * rotation_speed * delta)
	orthonormalize()
	_camera_rotation_pivot.rotate_x(_tilt_input * tilt_speed * delta)
	_camera_rotation_pivot.rotation_degrees.x = clamp(
		_camera_rotation_pivot.rotation_degrees.x, tilt_upper_limit, tilt_lower_limit
	)
	_yaw_input = 0.0
	_tilt_input = 0.0
