extends BasePlayerPlatformer3D

export var stomp_bump_strength := 4.0


func _physics_process(delta: float) -> void:
	apply_base_movement(delta)
	stomp()

func stomp() -> void:
	# If we fell on top of an enemy, KinematicBody considers that we are on
	# the floor. We only run the stomp code if is_on_floor() returns true and
	# we're landing this frame.
	if not (is_landing() and is_on_floor()):
		return

	for index in get_slide_count():
		# We loop over all the collisions this frame and if one of the things we
		# collided with is an enemy, we destroy it and jump.
		var collision := get_slide_collision(index)
		# To detect enemies, we use a node group here, but you could also use
		# the is keyword and check for a specific type.
		#
		# Or you could use duck typing and check that the entity has a "die"
		# function for example.
		if collision.collider.is_in_group("enemy"):
			collision.collider.die()
			_velocity.y += stomp_bump_strength
