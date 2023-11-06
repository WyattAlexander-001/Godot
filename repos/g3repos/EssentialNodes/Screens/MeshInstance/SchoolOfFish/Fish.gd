extends MultiMeshInstance

export var separation_weight := 0.05
export var alignment_weight := 0.02
export var cohesion_weight := 0.01
export var bound_weight := 0.15
export var fish_speed := 4.0
export var fish_separation_squared := 1.5 * 1.5
export var bounding_box := AABB()

var _fish := []


class Fish:
	var transform := Transform()
	var direction := Vector3.ZERO
	var index := 0

	func _init(transform: Transform, direction: Vector3, index: int) -> void:
		self.transform = transform
		self.direction = direction
		self.index = index

func _ready() -> void:
	randomize()
	for index in multimesh.instance_count:
		# We calculate a random position and direction at which each fish starts.
		var start_position := Vector3(
			rand_range(bounding_box.position.x, bounding_box.end.x),
			rand_range(bounding_box.position.y, bounding_box.end.y),
			rand_range(bounding_box.position.z, bounding_box.end.z)
		)
		var starting_transform := Transform(Basis(), start_position)
		var starting_direction := Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)).normalized()
		# We store each fish in an array to keep track of the starting transform
		# and move direction.
		_fish.append(Fish.new(starting_transform, starting_direction, index))
		# We initialize the fishes' starting positions and colors.
		multimesh.set_instance_transform(index, starting_transform)
		multimesh.set_instance_color(index, Color(randf(), randf(), 0.5))

func _physics_process(delta: float) -> void:
	# Every frame, we find the path for each fish and move them in that direction.
	for current_fish in _fish:
		var move_direction := _calculate_boid_direction(current_fish)
		current_fish.direction = (current_fish.direction + move_direction).normalized()
		# We orient the fish to look in the direction of travel.
		current_fish.transform = current_fish.transform.looking_at(
			current_fish.transform.origin + current_fish.direction, Vector3.UP
		)
		current_fish.transform.origin += current_fish.direction * fish_speed * delta
		# Here we upload new transform data to the multimesh object.
		multimesh.set_instance_transform(current_fish.index, current_fish.transform)


# Combine all path parameters to generate a direction of travel for a fish.
#
# We use the boids algorithm to make fishes move relative to one another.
func _calculate_boid_direction(current_fish: Fish) -> Vector3:
	var cohesion := Vector3.ZERO
	var alignment := Vector3.ZERO
	var separation := Vector3.ZERO
	var bounding_force := Vector3.ZERO

	# Note this naive implementation has an exponential cost. It works for small
	# clumps of fishes but will become heavy for very large flocks.
	#
	# You can partition the fishes in a grid and only take nearby fishes into
	# account if you need larger flocks or swarms of boids.
	for fish in _fish:
		if fish != current_fish:
			cohesion += fish.transform.origin
			alignment += fish.direction
			# If a fish is too close to another apply a foce away from the neighbor.
			#
			# Notice the use of distance_squared_to(), which is faster than distance_to().
			if (
				fish.transform.origin.distance_squared_to(current_fish.transform.origin)
				< fish_separation_squared
			):
				separation -= fish.transform.origin - current_fish.transform.origin

	# Calculate mean cohesion and alignment.
	cohesion = cohesion / (_fish.size() - 1.0)
	alignment = alignment / (_fish.size() - 1.0)

	# Combine path forces with weights.
	cohesion = (cohesion - current_fish.transform.origin) * cohesion_weight
	alignment = (alignment - current_fish.direction) * alignment_weight
	separation *= separation_weight
	# If a fish is outside the bounding box, we apply a force towards the center.
	if not bounding_box.has_point(current_fish.transform.origin):
		bounding_force = -current_fish.transform.origin * bound_weight

	return cohesion + alignment + separation + bounding_force
