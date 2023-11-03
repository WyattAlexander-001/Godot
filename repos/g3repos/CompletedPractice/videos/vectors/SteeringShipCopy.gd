extends Sprite

var boost_speed := 1500.0
var normal_speed := 600.0

var max_speed := normal_speed
var velocity := Vector2.ZERO
export var drag_factor := 0.12

var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO

func _process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	desired_velocity = max_speed * direction
	steering_vector = desired_velocity - velocity
	velocity += steering_vector * drag_factor
	position += velocity * delta
	rotation = velocity.angle()
