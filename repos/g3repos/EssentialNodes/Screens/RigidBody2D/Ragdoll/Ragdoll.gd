extends RigidPlayer2D

onready var _particles := $Particles2D


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	for child in get_children():
		if child is RigidBody2D:
			child.global_rotation = _sprite.rotation


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		explode()


func explode() -> void:
	if not _sprite.visible:
		return
	_particles.restart()
	_sprite.visible = false
	for child in get_children():
		if child is RigidBody2D:
			child.visible = true
			child.mode = MODE_RIGID
			child.apply_central_impulse(1000 * Vector2(rand_range(-1, 1), rand_range(-1, 1)))
	mode = MODE_KINEMATIC
