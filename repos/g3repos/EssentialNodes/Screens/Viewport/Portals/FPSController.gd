extends KinematicBody

const ROTATION_DIVIDER := 100.0

const SPEED := 8.0
const MOUSE_SENSITIVITY := 0.4

var _velocity := Vector3.ZERO

onready var _camera: Camera = $PlayerCamera


func _physics_process(_delta):
	var direction := Vector3.ZERO
	if Input.get_action_strength("move_down"):
		direction += transform.basis.z
	if Input.get_action_strength("move_up"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	direction = direction.normalized()

	_velocity = direction * SPEED
	move_and_slide(_velocity, Vector3.UP)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY / ROTATION_DIVIDER)
		_camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY / ROTATION_DIVIDER)
		_camera.rotation.x = clamp(_camera.rotation.x, -PI / 2, PI / 2)
	if event.is_action_pressed("interact"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
