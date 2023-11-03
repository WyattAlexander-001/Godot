# Too much for the start project, requires too many changes over steering ship to make it feel good.
extends Sprite

const ARRIVE_RADIUS := 120.0
const ARRIVE_THRESHOLD := 8.0

export var max_speed := 800.0

var speed := max_speed
var velocity := Vector2.ZERO
var drag_factor := 0.1


func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("click"):
		direction = global_position.direction_to(get_global_mouse_position())

	var distance := global_position.distance_to(get_global_mouse_position())

	speed = max_speed
	if distance < ARRIVE_THRESHOLD:
		speed = 0.0
	elif distance < ARRIVE_RADIUS:
		speed *= distance / ARRIVE_RADIUS

	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	position += velocity * delta
	rotation = velocity.angle()
