extends Node2D

onready var _field: Node2D = $Field
onready var _asteroids: Node2D = $Asteroids


func _physics_process(_delta: float) -> void:
	for asteroid in _asteroids.get_children():
		asteroid.applied_force = get_force(asteroid.position)
		asteroid.line.points[1] = asteroid.applied_force.rotated(-asteroid.rotation)


## Calculate a force at the given input position, based on the proximity to the
## available paths.
func get_force(input_position: Vector2) -> Vector2:
	var force := Vector2.ZERO

	for path in _field.get_children():
		var path_follow: PathFollow2D = path.get_node("PathFollow2D")

		# Move `PathFollow2D` to the closest point to `input_position`, on the curve.
		path_follow.offset = path.curve.get_closest_offset(input_position)

		# Calculate the force at `distance` given the decay `Curve`.
		var vector_from_input_position := path_follow.position - input_position
		var force_size_at_distance = path.force_size * path.decay_curve.interpolate_baked(
			min(vector_from_input_position.length() / path.decay_distance, 1.0)
		)
		force += force_size_at_distance * path_follow.transform.x

	return force
