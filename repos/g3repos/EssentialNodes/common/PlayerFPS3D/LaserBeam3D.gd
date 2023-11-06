extends Spatial
export var camera_ray_path: NodePath

onready var _camera_ray: RayCast = get_node(camera_ray_path)
onready var _model: Spatial = $Model
onready var _beam_mesh: Spatial = $Model/BeamMesh
onready var _collision_particles: Particles = $CollisionParticles
onready var _beam_particles: Particles = $Model/BeamParticles
func _physics_process(_delta: float) -> void:
	_camera_ray.force_raycast_update()
	
	var is_firing := Input.is_action_pressed("shoot_3d")
	_collision_particles.emitting = is_firing
	_beam_particles.emitting = is_firing
	_beam_mesh.visible = is_firing
	
	if not is_firing:
		return
	var target: Vector3
	var direction: Vector3
	if _camera_ray.is_colliding():
		var body = _camera_ray.get_collider()
		if body.has_method("take_damage"):
			body.take_damage()
		target = _camera_ray.get_collision_point()
		direction = target + _camera_ray.get_collision_normal()
	else:
		target = _camera_ray.to_global(_camera_ray.cast_to)
		direction = global_transform.origin
	_cast_beam(target, direction)


func _cast_beam(target: Vector3, direction: Vector3) -> void:
	var distance = _model.global_transform.origin.distance_to(target)
	_model.look_at(target, Vector3.UP)
	_model.scale.z = distance
	_collision_particles.global_transform.origin = target
	_collision_particles.look_at(direction, global_transform.basis.z)
