extends KinematicBody2D

const SPRITE_ANGLE_OFFSET := PI / 2.0

var speed := 800.0

var _velocity := Vector2.ZERO
var _target_rotation := SPRITE_ANGLE_OFFSET

# Reference to a rock to push. If set, every frame, we move the rock along with
# the ship.
#
# You may experience stutters when trying to push multiple objects at once, as
# we only track one at a time here.
var _rock_to_push: KinematicBody2D = null
## Direction in which the player was moving when first pushing the rock.
var _push_direction := Vector2.ZERO
## Threshold beyond which we detach a rock from the player.
# In some cases, when you push the rock towards a surface and the character
# splits away, we need this to stop the rock from moving away from the player.
var _detach_distance := 0.0

onready var _sprite := $Sprite


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()

	# We need to move the rock before the player's ship to prevent stutters.
	#
	# We push the rock as long as the player keeps pushing in the same
	# direction.
	#
	# If they change direction, we remove the reference to the rock and stop
	# pushing.
	_velocity = direction * speed
	if _rock_to_push and direction == _push_direction:
		_rock_to_push.move_and_slide(_velocity)
	move_and_slide(_velocity)

	if _rock_to_push:
		# There are two cases we want to stop pushing the rock:
		#
		# 1. The player changes direction.
		# 2. The rock and the player split over an angle in the environment,
		#    causing the player and the rock to move away from one another.
		var rock_distance := global_position.distance_to(_rock_to_push.global_position)
		if direction != _push_direction or rock_distance > _detach_distance:
			_rock_to_push = null

	# Detecting and pushing rocks.
	#
	# We loop over everything we collided with this frame and check if it's a
	# rock.
	for index in get_slide_count():
		var collision := get_slide_collision(index)
		var collider := collision.collider as KinematicBody2D
		# As we use the type hint `KinematicBody2D` above, if the `collider` is
		# not of that type, the variable will be `null`.
		if collider != null and collider.is_in_group("rock"):
			# If this is a rock to push, we store a reference to it and the
			# player's direction this frame.
			_rock_to_push = collider
			_push_direction = direction
			# If the rock is farther than this distance from the player, we stop
			# pushing it. We store the initial distance with a one-pixel margin.
			_detach_distance = global_position.distance_to(collider.global_position) + 1.0
			break

	# Animating the sprite's rotation.
	if not direction.is_equal_approx(Vector2.ZERO):
		_target_rotation = direction.angle() + SPRITE_ANGLE_OFFSET
	_sprite.rotation = lerp_angle(_sprite.rotation, _target_rotation, 15.0 * delta)
