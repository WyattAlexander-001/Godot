extends "../04.Variations/Turret.gd"

# The amount by which we divide the speed of mobs in range of the turret.
const SPEED_DIVIDER := 2.0
# We use this color to tint the mobs in range.
const COLOR := Color(0.4, 0.6, 1.0)


func _ready() -> void:
	set_physics_process(false)


func _on_Timer_timeout() -> void:
	# We don't want to shoot, so we override the function to do nothing.
	return


func _on_body_entered(body: Node) -> void:
	# Call the function _on_body_entered() from Turret.gd
	._on_body_entered(body)
	# We reduce the mob's speed and change its tint.
	body.speed /= SPEED_DIVIDER
	body.modulate = COLOR


func _on_body_exited(body: Node) -> void:
	._on_body_exited(body)
	# We restore the mob's original speed and remove the tint.
	body.speed *= SPEED_DIVIDER
	body.modulate = Color(1.0, 1.0, 1.0)
