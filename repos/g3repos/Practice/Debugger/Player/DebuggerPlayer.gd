class_name DebuggerPlayer
extends DebuggerActor

signal game_over_animation_finished

onready var _animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	_animation_player.connect("animation_finished", self, "_on_animation_finished")
	_animation_player.play("idle")


func is_playing_animation() -> bool:
	return _animation_player.is_playing()


func play_level_passed_animation() -> void:
	_animation_player.play("level")


func play_game_over_animation() -> void:
	_animation_player.play("damage")


func _on_animation_finished(_anim: String) -> void:
	emit_signal("game_over_animation_finished")
