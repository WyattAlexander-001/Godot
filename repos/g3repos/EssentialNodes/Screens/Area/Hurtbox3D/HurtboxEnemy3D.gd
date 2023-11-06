extends KinematicBody

export var speed := 3.0
export var steer_force := 2.0
export var snap_length := 0.05
export var jump_force := 6.0
export var rotation_speed := 8.0

var _snap := Vector3.DOWN * snap_length
var _acceleration := Vector3.ZERO
var _last_direction: Vector3
var _velocity := Vector3.ZERO
var _y_velocity: float

onready var _gravity: float = -ProjectSettings.get_setting("physics/3d/default_gravity")

onready var _animation_player: AnimationPlayer = $Model/RobotSkin/AnimationPlayer
onready var _blocked_check_raycast: RayCast = $Model/RayCast
onready var _start_position := global_transform.origin
onready var _target: Spatial = $"../../Player3D"
onready var _hitbox: Area = $HitBox
onready var _hurtbox: Area = $HurtBox
onready var _model := $Model
onready var _collision_shape := $CollisionShape
onready var _smoke_particles := $Smoke


func _ready() -> void:
	_hitbox.connect("body_entered", self, "_on_HitBox_body_entered")
	_hurtbox.connect("area_entered", self, "_on_HurtBox_area_entered")
	_model.rotate_y(rand_range(0.0, 360))
	_velocity = global_transform.basis.z * speed


func _physics_process(delta: float) -> void:
	if _velocity.length() > 0.1:
		_last_direction = (_velocity * Vector3(1.0, 0.0, 1.0)).normalized()
	_orient_character_to_direction(_last_direction, delta)

	_y_velocity = _velocity.y
	_velocity.y = 0.0

	if is_on_floor():
		_y_velocity = 0.0
	else:
		_y_velocity += _gravity * delta

	if _blocked_check_raycast.is_colliding() and is_on_floor():
		_y_velocity = jump_force

	_acceleration += _get_steering()
	_velocity += _acceleration * delta
	if _velocity.length() > speed:
		_velocity = _velocity.normalized() * speed

	_velocity.y = _y_velocity
	_velocity = move_and_slide_with_snap(_velocity, _snap, Vector3.UP, true)


func take_damage() -> void:
	_animation_player.play("Die")
	_collision_shape.set_deferred("disabled", true)
	_hurtbox.set_deferred("monitoring", false)
	_hitbox.set_deferred("monitoring", false)
	set_physics_process(false)
	_smoke_particles.emitting = true

func reset_position() -> void:
	global_transform.origin = _start_position


func _get_steering() -> Vector3:
	var steer := Vector3.ZERO
	var target_steer := (
		(_target.global_transform.origin - global_transform.origin).normalized()
		* speed
	)
	target_steer.y = 0.0
	steer = (target_steer - _velocity).normalized() * steer_force
	return steer


func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction)
	_model.transform.basis = _model.transform.basis.slerp(rotation_basis, delta * rotation_speed)


func _on_HitBox_body_entered(body: PhysicsBody) -> void:
	if body.has_method("take_damage"):
		body.take_damage()


func _on_HurtBox_area_entered(area: Area) -> void:
	take_damage()
