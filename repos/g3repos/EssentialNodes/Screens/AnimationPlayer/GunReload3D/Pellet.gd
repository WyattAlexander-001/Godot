extends RayCast

const SPREAD := 5
const PELLET_FORCE := 5
onready var _animator: AnimationPlayer = $AnimationPlayer
onready var _particles: Particles = $Particles


func _ready() -> void:
	_particles.set_as_toplevel(true)
	rotation_degrees.x = rand_range(-SPREAD, SPREAD)
	rotation_degrees.y = rand_range(-SPREAD, SPREAD)
	_animator.play("Fire")
	force_raycast_update()
	var _collider = get_collider()
	if _collider is RigidBody:
		_collider.apply_central_impulse(to_global(cast_to).normalized() * PELLET_FORCE)
	_particles.global_transform.origin = get_collision_point()
