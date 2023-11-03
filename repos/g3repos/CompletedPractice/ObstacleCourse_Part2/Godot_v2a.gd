extends KinematicBody2D


const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

const SPEED := 700.0

var drag_factor: float = 0.13
var velocity := Vector2.ZERO

# We store the active collision layers and masks at the start of the game to 
# later toggle them on and off using code.
var start_collision_layer := collision_layer
var start_collision_mask := collision_mask

onready var sprite := $Sprite
onready var animation_player_ghost := $AnimationPlayerGhost
onready var timer_ghost := $TimerGhost


func _ready() -> void:
	# We directly connect the signal to toggle_ghost_effect, and ask Godot to
	# call the function with a value of `false`.
	timer_ghost.connect("timeout", self, "toggle_ghost_effect", [false])


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := SPEED * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	move_and_slide(velocity)

	var direction_to_frame_key := direction.round()
	direction_to_frame_key.x = abs(direction_to_frame_key.x)
	if direction_to_frame_key in DIRECTION_TO_FRAME:
		sprite.frame = DIRECTION_TO_FRAME[direction_to_frame_key]
		sprite.flip_h = sign(direction.x) == -1


# This function activates or deactivates the ghost effect depending on the
# `is_on` argument.
func toggle_ghost_effect(is_on: bool) -> void:
	if is_on:
		timer_ghost.start()
		# We turn off collision detection by setting both the collision layer
		# and mask to 0.
		collision_layer = 0
		collision_mask = 0
		animation_player_ghost.play("ghost")
	else:
		# When turning off the effect, we restore the original collision layer
		# and mask.
		collision_layer = start_collision_layer
		collision_mask = start_collision_mask
		animation_player_ghost.stop()
