extends BasePlayerPlatformer3D

export var push_strength := 0.5

var _is_pushing := false

func _physics_process(delta: float) -> void:
	apply_base_movement(delta)
	push(delta)

func push(delta: float) -> void:
	# We have to always reset the property to only set it to true when the
	# character is pushing something.
	_is_pushing = false
	for index in get_slide_count():
		var collision := get_slide_collision(index)
		var collider := collision.collider
		# We loop over all the collisions that occured this frame and look for a
		# RigidBody2D.
		if collider is RigidBody:
			# We ensure that one not above the body using a vector.product. We
			# use it to compare the angle between the floor normal and the
			# collision normal.
			#
			# A value lower than 0.9 means that the 2 vectors are at an angle
			# lower than 90°.
			_is_pushing = collision.normal.dot(Vector3.UP) < 0.9
			_velocity = _move_direction * push_strength
			# We apply an impulse to push the body we are colliding with.
			collider.apply_central_impulse(_velocity.normalized() * push_strength * delta)
			break
	_model.is_pushing = _is_pushing
