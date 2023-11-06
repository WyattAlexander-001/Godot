extends KinematicBody2D

const SPEED := 65.0

onready var _timer: Timer = $Timer
onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _direction := Vector2.UP


func _ready() -> void:
	# The "Die" animation calls queue_free() on this node.
	_timer.connect("timeout", _anim_player, "play", ["Die"])


func _physics_process(_delta: float) -> void:
	var velocity = _direction * SPEED
	move_and_slide(velocity)
