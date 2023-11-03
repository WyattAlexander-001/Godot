# Simplified version of Bird.gd, in an attempt to make it easier for people.
extends KinematicBody2D

# Multiplier that controls how fast the entity changes speed and turns.
const DAMP_FACTOR := 0.15

export var fly_speed := 1200.0
export var fly_gravity := 1800.0
export var max_fall_speed := 1000.0

var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if not input_direction.is_equal_approx(Vector2.ZERO):
		var desired_velocity := input_direction * fly_speed
		var steering := desired_velocity - velocity
		velocity += steering * DAMP_FACTOR

	velocity.y += fly_gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

	var last_velocity := velocity
	velocity = move_and_slide(velocity)

	if get_slide_count() > 0:
		velocity = -1.0 * last_velocity.reflect(get_slide_collision(0).normal)
	rotation = velocity.angle()
