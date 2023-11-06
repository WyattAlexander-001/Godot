## Base class for side-scrolling characters in the `KinematicBody2D` demos.
##
## It allows us to share the same boilerplate between all side-scrolling
## characters.
##
## You need to extend this class and use or override its functions.
##
## We don't use _physics_process() here because of how Godot automatically calls
## the parent class's _physics_process() after the child class's.
tool
class_name BasePlayerSideScroll
extends KinematicBody2D

## A direction vector perpendicular to the floor. We pass it to the
## move_and_slide_with_snap() function so Godot knows if the body is on the
## floor, touching a wall, or against the ceiling.
const UP_DIRECTION := Vector2.UP

# We use these constant to calculate a snap vector when we want the character to
# snap to the floor.
#
# We use them below to initialize the `_snap_vector` variable.
const SNAP_DIRECTION := Vector2.DOWN
const SNAP_VECTOR_LENGTH := 32.0

## This is the maximum number of times Godot will try to move and slide the body
## against a wall or a slope to move it smoothly.
const MAX_SLIDES := 4
## The maximum angle a slope can have before the character starts to slide down,
## in radians.
##
## We use the deg2rad() function and to calculate a maximum slope of 46°,
## allowing the player to walk slopes with a 45° angle.
const MAX_SLOPE_ANGLE := deg2rad(46)

## The character's horizontal movement speed in pixels per second.
##
## When pressing the left and right arrow keys, the character instantly goes at
## this speed, as in games like Megaman.
export var speed := 600.0
## When the character jumps, we set their upward velocity to this value.
export var jump_strength := 1400.0
## This is the gravity in pixels per second squared, which we will apply every frame.
export var gravity := 4500.0

## The following 2 properties are arguments of the move_and_slide() function. We
## exported variables to toggle them on and off in different demos.
export var do_stop_on_slope := false
export var has_infinite_inertia := true

## The following pseudo-private variables keep track of the characters velocity,
## the snap vector, and the horizontal input direction, which we change regularly
## in the code.
var _velocity := Vector2.ZERO
var _snap_vector := SNAP_DIRECTION * SNAP_VECTOR_LENGTH
var _horizontal_direction := 0.0

## The following properties allow us to animate the character we designed for
## this demo and to mirror it horizontally.
onready var _pivot: Node2D = $PlayerSideSkin
onready var _anim_player: AnimationPlayer = $PlayerSideSkin/AnimationPlayer
onready var _start_scale := _pivot.scale

## Gets the player's input, updates the velocity, and moves the character.
func apply_base_movement(delta: float) -> void:
	# Input.get_action_strength() Returns a value between zero and one-based on
	# the players input.
	#
	# For buttons, the value will either be zero or one, but this function
	# supports analog input for joysticks and trigger buttons, giving you a
	# whole range of possible values.
	_horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	# The character moves horizontally without acceleration, but we constantly
	# apply the gravity to trigger collisions with the floor.
	_velocity.x = _horizontal_direction * speed
	_velocity.y += gravity * delta

	if is_jumping():
		_velocity.y = -jump_strength
		_snap_vector = Vector2.ZERO
	elif is_jump_cancelled():
		_velocity.y = 0.0
	elif is_landing():
		_snap_vector = SNAP_DIRECTION * SNAP_VECTOR_LENGTH

	_velocity = move_and_slide_with_snap(
		_velocity,
		_snap_vector,
		UP_DIRECTION,
		do_stop_on_slope,
		MAX_SLIDES,
		MAX_SLOPE_ANGLE,
		has_infinite_inertia
	)

## Returns `true` if the player is initiating a jump.
func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump") and is_on_floor()


## Returns `true` if the player released the jump input action while jumping.
func is_jump_cancelled() -> bool:
	return Input.is_action_just_released("jump") and _velocity.y < 0.0

## Returns `true` if the character is landing on the floor this frame.
func is_landing() -> bool:
	# When the _snap_vector is zero, it means the character jumped
	# If the character jumped then hit the floor it means it landed
	return _snap_vector == Vector2.ZERO and is_on_floor()

## Returns `true` if the character is falling.
func is_falling() -> bool:
	return _velocity.y > 0.0 and not is_on_floor()


## Returns `true` if the character is on the floor, running.
func is_running() -> bool:
	return is_on_floor() and not is_zero_approx(_horizontal_direction) and not is_on_wall()

## Returns `true` if character is on the floor, idling
func is_idling() -> bool:
	return is_zero_approx(_horizontal_direction) and is_on_floor()

## Updates the playing animation based on the character's state.
## To override in child classes to add support for more animations.
func update_animation() -> void:
	if is_jumping():
		_anim_player.play("jump")
	elif is_running():
		_anim_player.play("run")
	elif is_falling():
		_anim_player.play("fall")
	elif is_idling():
		_anim_player.play("idle")


## Flips the character horizontally to match the player's input direction.
func update_look_direction() -> void:
	if not is_zero_approx(_horizontal_direction):
		_pivot.scale.x = sign(_horizontal_direction) * _start_scale.x
