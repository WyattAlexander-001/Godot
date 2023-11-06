extends Spatial

onready var _field: Spatial = $Field
onready var _asteroids: Spatial = $Asteroids


func _physics_process(_delta: float) -> void:
	for asteroid in _asteroids.get_children():
		asteroid.add_central_force(calculate_force(asteroid.translation))


## Calculate a force at the given input position, based on the proximity to the
## available paths.
func calculate_force(input_position: Vector3) -> Vector3:
	var force := Vector3.ZERO

	for path in _field.get_children():
		var path_follow: PathFollow = path.get_node("PathFollow")

		# Move `PathFollow` to the closest point to `input_position`, on the curve.
		path_follow.offset = path.curve.get_closest_offset(input_position)

		# Calculate the force at distance given the decay `Curve`.
		var vector_from_input_position := path_follow.translation - input_position
		var force_size_at_distance = path.force_size * path.decay_curve.interpolate_baked(
			min(vector_from_input_position.length() / path.decay_distance, 1.0)
		)
		force += force_size_at_distance * path_follow.transform.basis.z

	return force
