extends KinematicBody

export var movement_speed := 1.5
export var rotation_speed := 12.0
export var acceleration := 3.0
export var snap_length := 0.05

var _velocity := Vector3.ZERO
var _movement_direction := Vector3.RIGHT

onready var _model: Spatial = $RobotSkin
onready var _animation_player: AnimationPlayer = $RobotSkin/AnimationPlayer
onready var _smoke_particles: Particles = $Smoke


func die() -> void:
	set_physics_process(false)
	set_collision_layer_bit(2, false)
	_animation_player.play("Die")
	_smoke_particles.emitting = true


func _physics_process(delta: float) -> void:
	_velocity = _velocity.linear_interpolate(
		_movement_direction * movement_speed, acceleration * delta
	)

	_velocity = move_and_slide_with_snap(_velocity, Vector3.DOWN * snap_length, Vector3.UP, true)

	if is_on_wall():
		_movement_direction = _movement_direction * Vector3.LEFT

	_orient_character_to_direction(_movement_direction, delta)


func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction).get_rotation_quat()
	var model_scale := _model.transform.basis.get_scale()
	_model.transform.basis = Basis(_model.transform.basis.get_rotation_quat().slerp(rotation_basis, delta * rotation_speed)).scaled(
		model_scale
	)
