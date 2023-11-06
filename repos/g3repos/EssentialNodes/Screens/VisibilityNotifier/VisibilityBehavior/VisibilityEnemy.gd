extends KinematicBody

signal is_visible(is_visible)

const FORCE_STRENGTH := 8.0
const ATTACK_RANGE := 5.0

# How accurately the enemy should point toward the player (in percentage) before
# allowing itself to fire at the player.
const ACCURACY := 0.999

export var rotation_speed := 8.0
export var snap_length := 0.05
export var drag := 14.0
export var speed := 6.0
export var player_path: NodePath

var _projectile_scene := preload("Projectile.tscn")
var _snap := Vector3.DOWN * snap_length
var _velocity := Vector3.ZERO
var _y_velocity: float

onready var _gravity: float = -ProjectSettings.get_setting(
	"physics/3d/default_gravity"
)
onready var visibility_notifier: VisibilityNotifier = $VisibilityNotifier
onready var _animator: AnimationPlayer = $AnimationPlayer
onready var _target: Player3D = get_node(player_path)
onready var _shot_origin: Spatial = $Model/ShotOrigin
onready var _model: Spatial = $Model

func _ready() -> void:
	visibility_notifier.connect(
		"screen_entered", self, "_on_VisibilityNotifier_screen_entered", [true]
	)
	visibility_notifier.connect(
		"screen_exited", self, "_on_VisibilityNotifier_screen_entered", [false]
	)

func _physics_process(delta: float) -> void:
	if _animator.is_playing():
		return
	var desired_velocity := Vector3.ZERO
	var direction := _velocity.normalized()

	if _target:
		direction = global_transform.origin.direction_to(
			_target.global_transform.origin
		)
		direction.y = 0.0
		direction = direction.normalized()
		var is_out_of_range := (
			global_transform.origin.distance_to(_target.global_transform.origin)
			> ATTACK_RANGE
		)
		desired_velocity = direction * speed if is_out_of_range else Vector3.ZERO
		_orient_character_to_direction(direction, delta)

		if not is_out_of_range and _is_looking_at_target(direction):
			_animator.play("Fire")

	_y_velocity = _velocity.y
	_velocity.y = 0.0

	if is_on_floor():
		_y_velocity = 0.0
	else:
		_y_velocity += _gravity * delta
	var steering := desired_velocity - _velocity
	_velocity += steering / drag
	_velocity = move_and_slide_with_snap(_velocity, _snap, Vector3.UP, true)

func _on_VisibilityNotifier_screen_entered(is_visible: bool) -> void:
	set_physics_process(is_visible)
	emit_signal("is_visible", is_visible)

func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction)
	_model.transform.basis = _model.transform.basis.orthonormalized().slerp(
		rotation_basis, delta * rotation_speed
	)


func _is_looking_at_target(direction: Vector3) -> bool:
	return _model.transform.basis.z.dot(direction) > ACCURACY


func _fire() -> void:
	var projectile = _projectile_scene.instance()
	projectile.direction = _model.transform.basis.z
	projectile.transform.origin = _shot_origin.transform.origin
	add_child(projectile)
