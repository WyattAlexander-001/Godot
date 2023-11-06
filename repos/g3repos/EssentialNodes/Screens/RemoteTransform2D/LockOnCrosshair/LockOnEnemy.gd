extends KinematicBody2D

const SPEED := 5.0

export var offset := Vector2()

var _circle_progress := 0.0
var _circle_position := Vector2()

onready var enemy_remote := $RemoteTransform2D

func _process(delta: float) -> void:
	_circle_progress += delta
	var direction := Vector2(sin(_circle_progress + (PI / 2.0)),  sin(_circle_progress))
	_circle_position += direction * SPEED
	rotation = direction.angle() + (PI / 2.0)
	position = _circle_position + offset
