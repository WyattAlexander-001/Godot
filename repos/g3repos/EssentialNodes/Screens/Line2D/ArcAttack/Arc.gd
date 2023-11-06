extends Node2D
onready var _path := $Path2D
onready var _line := $Line2D
onready var _particles := $Particles2D
onready var _animation_player := $AnimationPlayer


func _ready() -> void:
	set_as_toplevel(true)
	randomize()


func fire(origin: Vector2, target: Vector2, direction_in: Vector2) -> void:
	global_position = origin
	# Save the distance from the player to the target to figure out how wide our curve should arc.
	var vector_strength := origin.distance_to(target)
	# Offseting the target position slightly will make our shots look less robotic, hitting slightly around the target.
	var endpoint: Vector2 = target + get_random_vector(sqrt(vector_strength))
	# To generate our curve, we add our start and end points with in and out control points to control the curve.
	# We use direction_in, to have our curve start firing in the same direction the player is aiming at first.
	_path.curve.add_point(
		Vector2.ZERO,
		get_random_vector(vector_strength),
		direction_in * vector_strength * 0.5
	)
	# The target point has completely randomised control points, to create unique firing arcs.
	_path.curve.add_point(
		# Get the local position of the target to fire to
		to_local(endpoint),
		get_random_vector(vector_strength),
		get_random_vector(vector_strength)
	)
	# Now our curve is set up, we can convert it into a series of points for our Line2D
	_line.points = _path.curve.get_baked_points()
	# Put particles at the end and play our firing animation.
	_particles.global_position = endpoint
	_animation_player.play("Fire")


## Returns a random Vector2 from an input strength
func get_random_vector(strength_in: float) -> Vector2:
	return Vector2(
		rand_range(-strength_in, strength_in),
		rand_range(-strength_in, strength_in)
	)
