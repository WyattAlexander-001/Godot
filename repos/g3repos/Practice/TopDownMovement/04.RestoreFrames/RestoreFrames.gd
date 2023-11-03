extends Node2D


const SPEED := 700
# The keys are mapped to the wrong frames. Correct the values to get the correct
# sprite to show in every direction.
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 4,
	Vector2.DOWN + Vector2.RIGHT: 2,
	Vector2.RIGHT: 1,
	Vector2.UP + Vector2.RIGHT: 4,
	Vector2.UP: 5,
}

onready var player: KinematicBody2D = $Godot
onready var player_sprite: Sprite = $Godot/Sprite


func _physics_process(_delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	player.move_and_slide(SPEED * direction)

	var direction_to_frame_key := direction.round()
	
	direction_to_frame_key.x = abs(direction_to_frame_key.x)
	if direction_to_frame_key in DIRECTION_TO_FRAME:
		player_sprite.frame = DIRECTION_TO_FRAME[direction_to_frame_key]
		player_sprite.flip_h = sign(direction.x) == -1
