extends Node2D


const SPEED := 700
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.RIGHT: 2,
	Vector2.UP: 4,
}

onready var player: KinematicBody2D = $Godot
onready var player_sprite: Sprite = $Godot/Sprite

func _physics_process(_delta: float) -> void:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x = 1.0
	# complete the lines below for the other 4 directions
	elif Input.is_action_pressed("move_left"):
		pass
	elif Input.is_action_pressed("move_up"):
		pass
	elif Input.is_action_pressed("move_down"):
		pass
	
	player.move_and_slide(SPEED * direction)

	var direction_to_frame_key := direction.round()
	direction_to_frame_key.x = abs(direction_to_frame_key.x)
	if direction_to_frame_key in DIRECTION_TO_FRAME:
		player_sprite.frame = DIRECTION_TO_FRAME[direction_to_frame_key]
		player_sprite.flip_h = sign(direction.x) == -1
