extends KinematicBody2D

# Multiplier that controls how fast the entity changes speed and turns.
const DAMP_FACTOR := 0.15

# Speed in pixels per second when moving horizontally on the ground.
export var floor_speed := 300.0
export var floor_gravity := 3000.0
export var jump_force := 400.0
export var fly_speed := 1200.0
export var fly_gravity := 1800.0
export var max_fall_speed := 1000.0

var velocity := Vector2.ZERO
var state := "floor"


func _physics_process(delta: float) -> void:
	if state == "air":
		var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

		if not input_direction.is_equal_approx(Vector2.ZERO):
			var desired_velocity := input_direction * fly_speed
			var steering := desired_velocity - velocity
			velocity += steering * DAMP_FACTOR

		velocity.y += fly_gravity * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

		velocity = move_and_slide(velocity)
		rotation = velocity.angle()
		if is_on_floor():
			state = "floor"
			rotation = 0.0

	elif state == "floor":
		var floor_direction := Input.get_axis("move_left", "move_right")
		velocity.x = floor_direction * floor_speed
		velocity.y += floor_gravity * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = -jump_force
			else:
				state = "air"
		velocity = move_and_slide(velocity, Vector2.UP)
