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
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	player.move_and_slide(SPEED * direction)

	var direction_key := direction.round()
	# Complete the next lines
	direction_key.x
	if direction_key in DIRECTION_TO_FRAME:
		player_sprite.frame
		player_sprite.flip_h
