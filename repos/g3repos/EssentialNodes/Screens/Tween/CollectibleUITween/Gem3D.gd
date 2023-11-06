class_name Gem
extends Area

signal collected(gem)

onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _spawn_translation := Vector3.ZERO


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

	_spawn_translation = translation


func _on_body_entered(_body) -> void:
	set_deferred("monitoring", false)
	emit_signal("collected", self)


func reset() -> void:
	_animation_player.play("spawn")
	translation = _spawn_translation
	set_deferred("monitoring", true)
