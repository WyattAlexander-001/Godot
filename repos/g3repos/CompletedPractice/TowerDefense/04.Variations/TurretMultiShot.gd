extends "Turret.gd"

func _rotate_to_target() -> void:
	var target_angle := PI / 2
	if target_list:
		# We define a variable to calculate the targets' average position.
		var average_position := Vector2.ZERO
		# We loop over all targets and sum their positions.
		for target in target_list:
			average_position += target.global_position
		# We divide by the number of positions. That's our average position.
		average_position /= target_list.size()
		# We then calculate the angle to that point like before.
		target_angle = average_position.angle_to_point(global_position)
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)


func _on_Timer_timeout() -> void:
	for target in target_list:
		var rocket := preload("common/Rocket.tscn").instance()
		add_child(rocket)
		rocket.rotation = target.global_position.angle_to_point(cannon.global_position)
		rocket.global_position = cannon.global_position
