extends RigidBody2D

const MIN_LENGTH := 5.0
const MAX_LENGTH := 50.0

export var player_path: NodePath

onready var _player := get_node(player_path)
onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _line: Line2D = $Line2D


func _process(_delta: float) -> void:
	_line.points[1] = to_local(_player.global_position)
	_line.width = range_lerp(_line.points[1].length(), 0.0, 500.0, MAX_LENGTH, MIN_LENGTH)

func spawn() -> void:
	_animation_player.play("Spawn")
