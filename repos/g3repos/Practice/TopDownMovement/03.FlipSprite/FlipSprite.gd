extends Node2D


const SPEED := 700
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

onready var player: KinematicBody2D = $Godot
onready var player_sprite: Sprite = $Godot/Sprite


func _physics_process(_delta: float) -> void:
	# We use a different function to calculate the direction in practices to 
	# simulate input. Please don't mind this difference.
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		0.0
	)
	player.move_and_slide(SPEED * direction)

	var direction_to_frame_key := direction.round()
	
	direction_to_frame_key.x = abs(direction_to_frame_key.x)
	if direction_to_frame_key in DIRECTION_TO_FRAME:
		player_sprite.frame = DIRECTION_TO_FRAME[direction_to_frame_key]
		# Flip the sprite depending on the input direction.
