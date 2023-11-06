extends Node2D

export var level_start_path: NodePath
export var level_end_path: NodePath

onready var _level_start: float = get_node(level_start_path).global_position.x
onready var _level_end: float = get_node(level_end_path).global_position.x

onready var _player: KinematicBody2D = $PlayerSideScroll
onready var _progress_bar: ProgressBar = $CanvasLayer/MarginContainer/VBoxContainer/ProgressBar

func _process(_delta: float) -> void:
	# Sets the progress bar to a ratio from 0.0 to 1.0, depending on how close the player is to the level_end, relative to the level_start.
	_progress_bar.set_as_ratio(inverse_lerp(_level_start, _level_end, _player.global_position.x))
