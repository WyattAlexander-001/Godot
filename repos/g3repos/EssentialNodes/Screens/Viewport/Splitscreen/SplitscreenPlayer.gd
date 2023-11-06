extends KinematicBody

const SPEED := 8.0
const MOUSE_SENSITIVITY := 0.4
const GRAVITY := Vector3(0, 98.1, 0)

var _velocity := Vector3.ZERO

onready var _camera: Camera = $Camera


func _physics_process(delta: float) -> void:
	var _direction := Vector3.ZERO
	var _jump_vector := Vector3.ZERO

	if Input.get_action_strength("ui_down"):
		_direction += transform.basis.z
	if Input.get_action_strength("ui_up"):
		_direction -= transform.basis.z
	if Input.is_action_pressed("ui_left"):
		_direction -= transform.basis.x
	if Input.is_action_pressed("ui_right"):
		_direction += transform.basis.x

	_direction = _direction.normalized()
	_velocity = _direction * SPEED

	move_and_slide(_velocity, Vector3.UP)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
		_camera.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
		_camera.rotation.x = wrapf(_camera.rotation.x, deg2rad(-90), deg2rad(90))

		get_tree().set_input_as_handled()
