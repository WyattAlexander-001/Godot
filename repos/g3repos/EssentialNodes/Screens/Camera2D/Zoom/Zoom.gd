extends Camera2D

const ZOOM_OUT_SPEED := 8.0
const ZOOM_IN_SPEED := 18.0


func _physics_process(delta) -> void:
	if Input.is_action_pressed("interact"):
		zoom = lerp(zoom, Vector2(4, 4), delta * ZOOM_OUT_SPEED)
	else:
		zoom = lerp(zoom, Vector2(1, 1), delta * ZOOM_IN_SPEED)
