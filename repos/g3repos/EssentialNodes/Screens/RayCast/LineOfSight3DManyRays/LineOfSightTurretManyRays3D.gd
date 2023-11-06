extends Spatial

const DRAG_FACTOR := 6.0

export var player_path := NodePath()
export var ray_length := 8.0 setget set_ray_length
export var horizontal_ray_count := 2
export var vertical_ray_count := 2
export var horizontal_angle_interval_degrees := 2.5
export var vertical_angle_interval_degrees := 2.5
var is_targetting := false setget set_is_targetting
var target_position := Vector3.ZERO

onready var targetting_position := global_transform.origin + Vector3.FORWARD

onready var _player: Player3D = get_node_or_null(player_path)
onready var _player_animator: AnimationPlayer = _player.get_node("TargetAnimation")
onready var _turret_animator: AnimationPlayer = $Turret/AnimationPlayer
onready var _raycast_pivot: Spatial = $RayCastPivot
onready var _view_area: Area = $ViewArea
onready var _turret_center: Spatial = $Turret/turret_base/turret_housing/turret_center
onready var _turret_cannon: Spatial = $Turret/turret_base/turret_housing/turret_center/turret_cannon


func _ready() -> void:
	_view_area.connect("body_entered", self, "_on_ViewArea_body_entered")
	_view_area.connect("body_exited", self, "_on_ViewArea_body_exited")
	generate_raycast_nodes()
	look_at_player()
	set_physics_process(false)

func generate_raycast_nodes() -> void:
	for vertical_layer in vertical_ray_count:
		for horizontal_layer in horizontal_ray_count:
			var ray := RayCast.new()
			# We rotate every ray based on our interval to center them on the player.
			#
			# We first want to remap our layer index to center the values on 0.
			# The range_lerp() function remaps a value from one range (the
			# second and third arguments) to another (the last two arguments).
			ray.add_exception(self)
			var horizontal_multiplier := range_lerp(
				horizontal_layer,
				0.0,
				horizontal_ray_count,
				-horizontal_ray_count / 2.0,
				horizontal_ray_count / 2.0 + 1.0
			)
			var vertical_multiplier := range_lerp(
				vertical_layer,
				0.0,
				vertical_ray_count,
				-vertical_ray_count / 2.0,
				vertical_ray_count / 2.0 + 1.0
			)
			# Then, we multiply the angular interval by our multipliers.
			ray.rotate_y(deg2rad(horizontal_angle_interval_degrees) * horizontal_multiplier)
			ray.rotate_x(deg2rad(vertical_angle_interval_degrees) * vertical_multiplier)
			ray.cast_to.z = -ray_length
			ray.collision_mask = 3
			ray.enabled = true

			var debug = DebugDrawRayCast.new()
			ray.add_child(debug)
			_raycast_pivot.add_child(ray)
			# This group allows us to detect nodes that have debug drawing in node essentials.
			ray.add_to_group("Draw")


func _physics_process(_delta: float) -> void:
	look_at_player()

	set_is_targetting(does_see_player())
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


func look_at_player() -> void:
	target_position = _player.global_transform.origin + Vector3.UP * 1.5
	_raycast_pivot.look_at(target_position, Vector3.UP)

func does_see_player() -> bool:
	for ray in _raycast_pivot.get_children():
		if ray.is_colliding() and ray.get_collider().is_in_group("player"):
			return true
	return false

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
	for ray in _raycast_pivot.get_children():
		ray.cast_to.z = -ray_length


func _on_ViewArea_body_entered(body):
	if body.is_in_group("player"):
		set_physics_process(true)
		for ray in _raycast_pivot.get_children():
			ray.enabled = true


func _on_ViewArea_body_exited(body: CollisionObject):
	set_is_targetting(false)
	if body.is_in_group("player"):
		set_physics_process(false)
		for ray in _raycast_pivot.get_children():
			ray.enabled = false
