extends KinematicBody2D

# Notice how we capitalize the constant's name. We do this to distinguish them
# from variable names.
const SPEED := 700.0
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

# We need to get the Sprite node to change its frame and flip it horizontally.
onready var sprite := $Godot


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity := direction * SPEED
	move_and_slide(velocity)

	# The Vector2.round() function returns a new Vector2 with both the `x` and
	# `y` rounded out.
	var direction_key := direction.round()
	# The abs() function makes negative numbers positive.
	direction_key.x = abs(direction_key.x)
	if direction_key in DIRECTION_TO_FRAME:
		sprite.frame = DIRECTION_TO_FRAME[direction_key]
		# Notice how we directly assign the result of a comparison to flip_h.
		# The computer converts comparisons to either true or false, which is
		# compatible with boolean variables like flip_h.
		sprite.flip_h = sign(direction.x) == -1
