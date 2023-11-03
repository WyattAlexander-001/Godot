extends Sprite


var velocity := Vector2(500, 0)


func _process(delta: float) -> void:
	position += velocity * delta
	rotation = velocity.angle()
