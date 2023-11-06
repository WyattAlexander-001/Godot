extends Node2D

var boost_rate := 2.5
var player_base_speed := 0

onready var _tween := $Tween
onready var _timer := $CooldownTimer
onready var _player := $Player
onready var _boost_ui := $AbilityUI


func _ready() -> void:
	player_base_speed = _player.speed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		boost()


func boost() -> void:
	if not _timer.is_stopped():
		return

	_timer.start()
	_boost_ui.animate_cooldown(_timer.wait_time)
	# increase the players speed to give a rough dashing effect
	_tween.interpolate_property(
		_player,
		"speed",
		player_base_speed * boost_rate,
		player_base_speed,
		0.5,
		Tween.TRANS_EXPO,
		Tween.EASE_IN
	)
	_tween.interpolate_property(_player, "scale", Vector2.ONE * 1.5, Vector2.ONE, 0.5)
	_tween.start()


func _on_CooldownTimer_timeout() -> void:
	_boost_ui.refresh_icon()
	_player.start_blink()
