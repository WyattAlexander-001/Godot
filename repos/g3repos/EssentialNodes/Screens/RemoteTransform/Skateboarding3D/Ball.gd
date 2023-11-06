extends RigidBody
signal crash(contact)

const COLLISION_THRESHOLD := 8.0
const VERTICAL_IMPULSE := 25

var last_velocity = Vector3.ZERO

func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	# Check if any collisions exceed the threshold for a crash to occur.
	for contact in state.get_contact_count():
		var new_velocity = state.get_contact_collider_velocity_at_position(contact)
		# If the velocity has dropped by a large enough amount, our skateboarder is knocked off the board.
		if abs(new_velocity.length() - last_velocity.length()) > COLLISION_THRESHOLD:
			var impulse = last_velocity
			# Add a vertical component, to launch our skatebaorder slightly upwards
			impulse.y = VERTICAL_IMPULSE
			# The crash signal contains the former direction of motion, to launch the skateboarder in that direction
			emit_signal("crash", impulse)
		last_velocity = new_velocity
