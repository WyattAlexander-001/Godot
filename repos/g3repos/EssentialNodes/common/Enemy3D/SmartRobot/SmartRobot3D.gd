extends RigidBody
var move_force := 25.0
var turn_force := 4.0
var direction := Vector3.FORWARD
var _velocity := Vector3.ZERO

onready var _rays := $Rays.get_children()

func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	state.apply_central_impulse(global_transform.basis.z * move_force * state.step)

	var torque := Vector3.ZERO
	var is_colliding := false
	for ray in _rays:
		var raycast := ray as RayCast
		if raycast.is_colliding():
			is_colliding = true
			var magnitude := calculate_collision_magnitude(raycast)
			torque += Vector3.DOWN * raycast.cast_to.x * magnitude * turn_force * state.step

	# To avoid getting stuck we apply force in one direction if the torque is
	# close to even after colliding
	if is_colliding and abs(torque.y) < 0.01:
		torque.y = turn_force * state.step
	state.apply_torque_impulse(torque)

func calculate_collision_magnitude(cast: RayCast) -> float:
	var max_length := cast.cast_to.length()
	var collision_length := cast.to_local(cast.get_collision_point()).length()
	return 1.0 - (collision_length / max_length)
