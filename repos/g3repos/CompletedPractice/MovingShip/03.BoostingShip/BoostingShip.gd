extends Sprite

var boost_speed := 1500.0
var normal_speed := 600.0

var max_speed := normal_speed
var velocity := Vector2.ZERO


func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()

	velocity = direction * max_speed
	position += velocity * delta
	if direction:
		rotation = velocity.angle()


func _on_Timer_timeout() -> void:
	max_speed = normal_speed
