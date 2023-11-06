extends Spatial

export var player_path: NodePath
export var bullet: PackedScene
export var bullet_speed := 10.0

onready var _player:= get_node(player_path)
onready var _timer: Timer = $Timer
onready var _animation_player: AnimationPlayer = $Turret/AnimationPlayer
onready var _turret_center: Spatial = $Turret/turret_base/turret_housing/turret_center
onready var _turret_cannon: Spatial = $Turret/turret_base/turret_housing/turret_center/turret_cannon
onready var _shot_origin: Spatial = $Turret/turret_base/turret_housing/turret_center/turret_cannon/shot_origin


func _ready() -> void:
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_animation_player.play("armed")


func _physics_process(_delta: float) -> void:
		var direction = _turret_center.global_transform.origin.direction_to(_player.translation + Vector3.UP)

		var turret_z_axis = Vector3(direction.x, 0.0, direction.z).normalized()
		var turret_x_axis = turret_z_axis.cross(Vector3.UP).normalized()
		_turret_center.global_transform.basis = Basis(turret_x_axis, Vector3.UP, turret_z_axis)

		var turret_cannon_x_axis = direction.cross(Vector3.UP).normalized()
		var turret_cannot_y_axis = direction.cross(turret_cannon_x_axis).normalized()
		_turret_cannon.global_transform.basis = Basis(turret_cannon_x_axis, turret_cannot_y_axis, direction)


func _on_Timer_timeout() -> void:
	var new_bullet: RigidBody =  bullet.instance()
	_shot_origin.add_child(new_bullet)
	new_bullet.set_as_toplevel(true)
	new_bullet.apply_central_impulse(bullet_speed * _shot_origin.global_transform.basis.z)
	
