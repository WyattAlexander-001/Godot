extends RayCast


func _physics_process(_delta: float) -> void:
	if not is_colliding():
		return

	var collider = get_collider()
	if collider.has_method("highlight"):
		collider.highlight()
		if Input.is_action_just_pressed("shoot_3d"):
			collider.shatter()
