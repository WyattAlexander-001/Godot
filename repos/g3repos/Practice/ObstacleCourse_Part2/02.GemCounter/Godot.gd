extends KinematicBody2D


const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

const SPEED := 700

var drag_factor: float = 0.13
var velocity := Vector2.ZERO

onready var sprite: Sprite = $Sprite
onready var area: Area2D = $Area2D


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := SPEED * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	velocity = move_and_slide(velocity)

	var direction_to_frame_key := direction.round()
	direction_to_frame_key.x = abs(direction_to_frame_key.x)
	if direction_to_frame_key in DIRECTION_TO_FRAME:
		sprite.frame = DIRECTION_TO_FRAME[direction_to_frame_key]
		sprite.flip_h = sign(direction.x) == -1
