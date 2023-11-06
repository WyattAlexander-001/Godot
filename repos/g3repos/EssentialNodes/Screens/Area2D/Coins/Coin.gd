extends Area2D

# The drag is a divider which controls the coin's acceleration and the time it
# takes to change direction. A higher value makes it less reactive.
const DRAG := 14.0
var max_speed := 400.0

var _velocity := Vector2.ZERO


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta: float) -> void:
	# We detect attractors using `get_overlapping_areas()`
	var attractors := get_overlapping_areas()

	# If there is one or more overlapping areas, we steer towards the first one.
	if attractors:
		# The desired velocity is a vector of length `max_speed` pointing
		# towards the player.
		var desired_velocity: Vector2 = (
			(attractors[0].global_position - global_position).normalized()
			* max_speed
		)
		# The follow steering equation works like so:
		#
		# 1. We calculate the difference between the desired and current velocity.
		# 2. We add a fraction of that difference to the current velocity.
		var steering := desired_velocity - _velocity
		_velocity += steering / DRAG
	# In this basic example, we instantly stop the coin's movement if the
	# player gets too far.
	else:
		_velocity = Vector2.ZERO

	position += _velocity * delta


# We destroy the coin upon detecting a collision with the player.
func _on_body_entered(_body: Node) -> void:
	queue_free()
