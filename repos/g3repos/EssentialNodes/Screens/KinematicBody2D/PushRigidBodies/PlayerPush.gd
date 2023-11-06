extends BasePlayerSideScroll

## The "force" applied to the rigid body we are pushing.
export var push_strength := 6000.0
# We create a property to keep track of the pushing state as it relies on looping over the
# collisions. It would not be convenient to make as a reusable function.
var _is_pushing := false

func _ready() -> void:
	# Infinite inertia allows KinematicBody2D to push RigidBody2D nodes around
	# without getting slowed down. This is perfect for debris and other cosmetic
	# objects to push around, but would break our pushing mechanic.
	has_infinite_inertia = false


func _physics_process(delta: float) -> void:
	apply_base_movement(delta)
	push(delta)
	update_animation()
	update_look_direction()


## Attempts to push a colliding rigid body.
func push(delta: float) -> void:
	# We have to always reset the property to only set it to true when the
	# character is pushing something.
	_is_pushing = false
	for index in get_slide_count():
		var collision := get_slide_collision(index)
		var collider := collision.collider
		# We loop over all the collisions that occured this frame and look for a
		# RigidBody2D.
		if collider is RigidBody2D:
			# We ensure that one not above the body using a vector.product. We
			# use it to compare the angle between the floor normal and the
			# collision normal.
			#
			# A value lower than 0.9 means that the 2 vectors are at an angle
			# lower than 90°.
			_is_pushing = collision.normal.dot(UP_DIRECTION) < 0.9
			_velocity.x = _horizontal_direction * push_strength
			# We apply an impulse to push the body we are colliding with. You
			# can learn more about RigidBody2D and its functions in the
			# RigidBody2D guide.
			collider.apply_central_impulse(_velocity.normalized() * push_strength * delta)
			break


## We override the parent class's update_animation() to add support for the push animation.
func update_animation() -> void:
	if _is_pushing:
		_anim_player.play("push")
	elif is_jumping():
		_anim_player.play("jump")
	elif is_on_floor():
		if not is_zero_approx(_horizontal_direction) and not is_on_wall():
			_anim_player.play("run")
		else:
			_anim_player.play("idle")
	elif _velocity.y > 0.0:
		_anim_player.play("fall")
