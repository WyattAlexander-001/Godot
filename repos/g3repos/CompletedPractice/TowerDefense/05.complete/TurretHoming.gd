extends "../04.Variations/Turret.gd"

func _on_Timer_timeout() -> void:
	if not target:
		return
	# We instance the homing rocket instead of the regular rocket.
	var rocket := preload("HomingRocket.tscn").instance()
	add_child(rocket)
	# Like before, we place it and rotate it based on the cannon's tip.
	rocket.global_transform = cannon.global_transform
	# We give the rocket the target, so it has something to steer to.
	rocket.target = target
	# And finally, we give the rocket an initial impulse for natural motion.
	rocket.set_initial_velocity()
