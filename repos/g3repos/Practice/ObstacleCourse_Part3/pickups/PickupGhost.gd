# ANCHOR: extends
extends "Pickup.gd"
# END: extends


# ANCHOR: apply_effect
func apply_effect(body: Node) -> void:
	# We turn on the ghost effect on the character when it touches the pickup.
	body.toggle_ghost_effect(true)
# END: apply_effect
