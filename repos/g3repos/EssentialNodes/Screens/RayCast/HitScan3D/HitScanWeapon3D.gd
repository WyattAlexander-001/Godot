extends Spatial
export var spray_scene: PackedScene
export var raycast_path: NodePath

var spray_angle_range := 5.0
var min_range := 9.0
var max_range := 12.0

onready var _timer: Timer = $Timer
onready var _ray: RayCast = get_node(raycast_path)
func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot_3d"):
		shoot()

func shoot() -> void:
	if not _timer.is_stopped():
		return

	_timer.start()

	var shoot_vector: Vector3 = Vector3.FORWARD * rand_range(min_range, max_range)
	shoot_vector = shoot_vector.rotated(Vector3.RIGHT, rand_range(0.0, deg2rad(spray_angle_range)))
	shoot_vector = shoot_vector.rotated(Vector3.FORWARD, rand_range(0.0, TAU))
	var spray = spray_scene.instance()

	add_child(spray)
	_ray.cast_to = shoot_vector
	_ray.force_raycast_update()
	if _ray.is_colliding():
		spray.setup(global_transform.origin, _ray.get_collision_point())
		spray.hit(
			_ray.get_collision_point(),
			_ray.get_collision_normal(),
			(_ray.get_collision_point() - _ray.global_transform.origin).normalized()
		)
	else:
		spray.setup(global_transform.origin, _ray.to_global(shoot_vector))
