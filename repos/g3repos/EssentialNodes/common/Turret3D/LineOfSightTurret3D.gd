extends Spatial

const DRAG_FACTOR := 6.0

export var player_path: NodePath
export var ray_length := 50.0 setget set_ray_length

var is_targetting := false setget set_is_targetting
onready var targetting_position := global_transform.origin + Vector3.FORWARD

onready var _player: Player3D = get_node_or_null(player_path)
onready var _raycast: RayCast = $RayCast
onready var _turret_center: Spatial = $Turret/turret_base/turret_housing/turret_center
onready var _turret_cannon: Spatial = $Turret/turret_base/turret_housing/turret_center/turret_cannon
onready var _player_animator: AnimationPlayer = _player.get_node("TargetAnimation")
onready var _turret_animator: AnimationPlayer = $Turret/AnimationPlayer

func _process(_delta: float) -> void:
	# Adding a 1 unit vector offset to the player position, since the player's origin is at the ground
	var target_position: Vector3 = _player.global_transform.origin + Vector3.UP
	_raycast.look_at(target_position, Vector3.UP)
	
	var does_see_player: bool = _raycast.is_colliding() and _raycast.get_collider() == _player
	set_is_targetting(does_see_player)
	if is_targetting:
		var steering := target_position - targetting_position
		targetting_position += steering / DRAG_FACTOR
		var direction = _turret_center.global_transform.origin.direction_to(targetting_position)

		var turret_z_axis = Vector3(direction.x, 0.0, direction.z).normalized()
		var turret_x_axis = turret_z_axis.cross(Vector3.UP).normalized()
		_turret_center.transform.basis = Basis(turret_x_axis, Vector3.UP, turret_z_axis)

		var turret_cannon_x_axis = direction.cross(Vector3.UP).normalized()
		var turret_cannot_y_axis = direction.cross(turret_cannon_x_axis).normalized()
		_turret_cannon.global_transform.basis = Basis(turret_cannon_x_axis, turret_cannot_y_axis, direction)

func set_is_targetting(value: bool) -> void:
	if value != is_targetting:
		is_targetting = value
		if is_targetting:
			_player_animator.play("highlight")
			_turret_animator.play("armed")
		else:
			_player_animator.play_backwards("highlight")
			_turret_animator.play_backwards("armed")

func set_ray_length(value: float) -> void:
	ray_length = value
	if not is_inside_tree():
		yield(self, "ready")
	_raycast.cast_to.z = -ray_length
