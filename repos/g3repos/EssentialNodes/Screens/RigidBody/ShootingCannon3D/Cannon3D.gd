extends Spatial

export var cannon_ball_scene: PackedScene
export var cannon_power := 40.0

export var mouse_sensitivity := 0.25
export var rotation_speed := 1.0
export var tilt_speed := 1.0

export (float, 0, -45.0) var yaw_upper_limit := 45.00
export (float, 0, 45.0) var yaw_lower_limit := -45.00
export (float, -90, 0.0) var tilt_upper_limit := 20.0
export (float, 0.0, 90.0) var tilt_lower_limit := -45.0

var _yaw_input: float
var _tilt_input: float

onready var _tilt_pivot := $Camera
onready var _launch_point := $Camera/Model/LaunchPoint
onready var _timer := $Timer

func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_yaw_input = -event.relative.x * mouse_sensitivity
			_tilt_input = -event.relative.y * mouse_sensitivity

		if event.is_action_pressed("shoot_3d") and _timer.is_stopped():
			_timer.start()
			var cannon_ball: RigidBody = cannon_ball_scene.instance()
			_launch_point.add_child(cannon_ball)
			cannon_ball.set_as_toplevel(true)
			cannon_ball.apply_central_impulse(-_launch_point.global_transform.basis.z * cannon_power)


func _physics_process(delta: float) -> void:
	_yaw_input += (
		Input.get_action_strength("camera_left")
		- Input.get_action_strength("camera_right")
	)
	_tilt_input += Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down")

	rotate_y(_yaw_input * rotation_speed * delta)
	rotation_degrees.y = clamp(rotation_degrees.y, yaw_lower_limit, yaw_upper_limit)

	_tilt_pivot.rotate_x(_tilt_input * tilt_speed * delta)
	_tilt_pivot.rotation_degrees.x = clamp(
		_tilt_pivot.rotation_degrees.x, tilt_lower_limit, tilt_upper_limit
	)
	if Input.is_action_just_pressed("shoot_3d") and _timer.is_stopped():
		_timer.start()
		var cannon_ball: RigidBody = cannon_ball_scene.instance()
		_launch_point.add_child(cannon_ball)
		cannon_ball.set_as_toplevel(true)
		cannon_ball.apply_central_impulse(-_launch_point.global_transform.basis.z * cannon_power)

	# We reset input at the end of the frame rather than the start because at
	# the start we want to take into account mouse motion. See
	# _unhandled_input()
	_yaw_input = 0.0
	_tilt_input = 0.0
