extends KinematicBody2D # Adapted from /common/PlayerSideScroll/PlayerSideScroll.gd

const FLOOR_NORMAL := Vector2.UP

export var speed := Vector2(650.0, 1600.0)
export var gravity := 3250.0

var _velocity := Vector2.ZERO

onready var _model: AstronautSkin = $Viewport/AstronautSkin

func _physics_process(delta: float) -> void:
	var direction := calculate_move_direction()

	_velocity.x = speed.x * direction.x
	_velocity.y += gravity * delta

	if is_equal_approx(direction.y, -1.0):
		_velocity.y = speed.y * direction.y

	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	if is_jump_interrupted:
		_velocity.y = 0.0

	if is_jumping():
		_model.jump()

	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	_model.velocity = Vector3(_velocity.x, _velocity.y, 0)
	_model.rotation_degrees.y = 90 * direction.x


func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump") and is_on_floor()


func calculate_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-int(Input.is_action_just_pressed("jump")) if is_on_floor() else 0.0
	)
