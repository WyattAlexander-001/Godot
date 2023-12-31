extends Sprite

var boost_speed := 1500
var normal_speed := 600
var max_speed := normal_speed
var velocity := Vector2.ZERO # Start at 0
var drag_factor := 0.1

func _process(delta: float) -> void:
	
	
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right") # -/+
	direction.y = Input.get_axis("move_up", "move_down") # -/+
	
	if direction.length() >1.0:
		direction = direction.normalized()
	
	if Input.is_action_just_pressed("spacebar"):
		max_speed = boost_speed
		get_node("Timer").start()
		
	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	position += velocity * delta
	rotation = velocity.angle()

func _on_Timer_timeout() -> void:
	max_speed = normal_speed
