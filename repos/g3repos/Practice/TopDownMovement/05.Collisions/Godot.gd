extends KinematicBody2D

const SPEED := 400
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

onready var sprite: Sprite = $Sprite

var direction := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	move_and_slide(SPEED * direction)

	var direction_key := direction.round()
	direction_key.x = abs(direction_key.x)
	if direction_key in DIRECTION_TO_FRAME:
		sprite.frame = DIRECTION_TO_FRAME[direction_key]
		sprite.flip_h = sign(direction.x) == -1
