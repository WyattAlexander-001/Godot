extends "../common/Rocket.gd"

var target: PhysicsBody2D
var velocity := Vector2(0, 0)
var drag_factor := 0.1


func set_initial_velocity() -> void:
	velocity = transform.x * speed


func _process(delta: float) -> void:
	if not target or not is_instance_valid(target):
		return

	var direction := global_position.direction_to(target.global_position)
	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	position += velocity * delta
	rotation = velocity.angle()
