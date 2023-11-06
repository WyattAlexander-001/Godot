extends FPSPlayer

const MIN_RUN_VELOCITY := 1.0

var target_speed
var target_fov

export var sprint_speed := 10.0
export var sprint_field_of_view := 90.0

onready var original_speed := move_speed
onready var _camera: Camera = $TiltPivot/Camera
onready var default_field_of_view := _camera.fov


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("dash") and _velocity.length_squared() > MIN_RUN_VELOCITY:
		target_speed = sprint_speed
		target_fov = sprint_field_of_view
	else:
		target_speed = original_speed
		target_fov = default_field_of_view
	move_speed = lerp(move_speed, target_speed, delta * acceleration)
	_camera.fov = lerp(_camera.fov, target_fov, delta * acceleration)
