extends Sprite
# WB
var max_speed := 600.0
var velocity := Vector2.ZERO

func _process(delta: float) -> void:
	# Calculate the input direction using Input.get_axis().
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right") # -/+
	direction.y = Input.get_axis("move_up", "move_down") # -/+
	
	# Limit the direction vector's length by normalizing the vector.
	# You need to replace "pass" below.
	if direction.length() > 1.0:
		direction = direction.normalized()

	# Complete this line to move the ship.
	velocity = direction * max_speed
	position += velocity * delta # moves ship

	position += velocity * delta
	if direction:
		rotation = velocity.angle() # rotates ship nose
