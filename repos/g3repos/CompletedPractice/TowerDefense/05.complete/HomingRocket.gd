extends "../common/Rocket.gd"

var velocity := Vector2(0, 0)
var drag_factor := 0.1
# The turret will provide the rocket with this target, one of the mobs.
var target: PhysicsBody2D = null


# This function gets called automatically in _physics_process() because we call
# it in the parent Rocket.gd script.
func _move(delta: float) -> void:
	# If the target has not been set, or has been destroyed, we destroy this
	# rocket.
	if not target or not is_instance_valid(target):
		explode()
		return
	# Calculate the direction to the target
	var direction := global_position.direction_to(target.global_position)
	# Steer to the target
	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	position += velocity * delta
	rotation = velocity.angle()


# The turret that shoots this rocket should call this function to give the
# rocket an initial impulse.
func set_initial_velocity() -> void:
	velocity = transform.x * speed
