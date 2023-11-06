
## Side-scrolling playable character with the ability to jump, run, cancel jump, 
## and stomp enemies.
extends BasePlayerSideScroll

# Similarly to jump_strength, we apply this to the character's vertical velocity
# and make it do hop after stomping an enemy.
export var stomp_bump_strength := 1000.0

# The character uses the same parent class as the basic side-scroll movement
# demo, but we add a stomp function in case we fall on an enemy.
func _physics_process(delta: float) -> void:
	update_animation()
	update_look_direction()
	apply_base_movement(delta)
	stomp()


## Checks if we fell on an enemy and if so, kills the enemy and makes the
## character jump.
func stomp() -> void:
	# If we fell on top of an enemy, KinematicBody2D considers that we are on
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
			collision.collider.take_damage()
			_velocity.y -= stomp_bump_strength
