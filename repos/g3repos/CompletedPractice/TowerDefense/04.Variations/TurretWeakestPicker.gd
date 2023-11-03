extends "Turret.gd"


func select_target() -> void:
	if target_list:
		# We start with a default target to compare against.
		target = target_list[0]
		# We then loop over all targets in the list to compare their health
		# against the current target.
		for potential_target in target_list:
			# If the potential target has lower health, it replaces the current
			# target.
			if potential_target.health < target.health:
				target = potential_target
	# This part is the same as in Turret.gd, if there are no potential targets,
	# we unset the target.
	else:
		target = null
