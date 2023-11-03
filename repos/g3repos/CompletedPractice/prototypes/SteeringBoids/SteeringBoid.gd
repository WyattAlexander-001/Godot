# Little animal that steers towards the mouse and away from other animals.
extends Area2D

# Multiplier that controls how fast the entity changes speed and turns.
const DAMP_FACTOR := 0.1
# Distance in pixels below which the entity moves away from the mouse.
const REPEL_DISTANCE := 200.0
# Distance in pixels below which the entity moves away from other entities.
const AVOID_DISTANCE := 80.0
# Multiplier that controls how fast the entity reacts to neighbors and moves away from them.
const AVOID_DAMP_FACTOR := 0.05

# Maximum follow speed in pixels per second.
var max_speed := 600.0
# The current velocity in pixels per second.
var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var target_position := get_global_mouse_position() - global_position
	var direction_to_target := global_position.direction_to(get_global_mouse_position())

	# Steering from the current position towards the mouse position.
	var desired_velocity := direction_to_target * max_speed
	var steering := desired_velocity - velocity
	velocity += steering * DAMP_FACTOR

	# Move away from the mouse when getting too close.
	var distance_to_target := target_position.length()
	if distance_to_target < REPEL_DISTANCE:
		var repel_factor := 1.0 - distance_to_target / REPEL_DISTANCE
		velocity -= direction_to_target * max_speed * repel_factor

	# Avoid other animals.
	for animal in get_overlapping_areas():
		var distance := position.distance_to(animal.position)
		if distance < AVOID_DISTANCE:
			var avoid_direction := -position.direction_to(animal.position)
			velocity += avoid_direction * max_speed * AVOID_DISTANCE / distance * AVOID_DAMP_FACTOR

	position += velocity * delta
	rotation = velocity.angle()
