class_name Pickup
extends Area2D

onready var _audio := $AudioStreamPlayer2D as AudioStreamPlayer2D
onready var _animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	_animation_player.play("idle")
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body) -> void:
	if body is Player:
		_pickup(body)
		_animation_player.play("destroy")
		set_deferred("monitoring", false)


func _pickup(_player: Player) -> void:
	pass
