class_name DebuggerPlayerInput
extends Node

onready var _stage = null


func setup(stage) -> void:
	_stage = stage


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		_stage.play_turn(Vector2.LEFT)
	elif Input.is_action_just_pressed("move_right"):
		_stage.play_turn(Vector2.RIGHT)
	elif Input.is_action_just_pressed("move_up"):
		_stage.play_turn(Vector2.UP)
	elif Input.is_action_just_pressed("move_down"):
		_stage.play_turn(Vector2.DOWN)
