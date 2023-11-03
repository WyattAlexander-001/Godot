tool
extends Node2D


export var curve: Curve = Curve.new()
export var duration := 1.0 setget set_duration
export var is_playing := false setget set_is_playing


onready var _tween: SceneTreeTween
onready var _start_position := $PositionStart as Position2D
onready var _end_position := $PositionEnd as Position2D
onready var _ball := $Ball as Sprite


func _ready() -> void:
	_start_tweening()


func _start_tweening() -> void:
	if _tween:
		_tween.kill()
		_tween = null
	
	_tween = create_tween()
	_tween.tween_method(self, "_animate", 0.0, 1.0, duration, [ 1.0 ])
	_tween.tween_method(self, "_animate", 1.0, 0.0, duration, [ -1.0 ])
	_tween.set_loops()


func _animate(value: float, _direction: float) -> void:
	assert(curve != null, "You need to specify a curve")
	if not curve:
		return
	if not is_inside_tree():
		yield(self, "ready")
	if not _ball:
		return
	var real_value := curve.interpolate(value)
	_ball.position = lerp(_start_position.position, _end_position.position, real_value)


func set_is_playing(is_it: bool) -> void:
	is_playing = is_it
	if not is_inside_tree():
		yield(self, "ready")
	if is_playing:
		_tween.play()
	else:
		_tween.pause()


func set_duration(new_duration: float) -> void:
	duration = new_duration
	_start_tweening()
