extends Node2D

onready var _area: Area2D = $Area2D


func _ready() -> void:
	_area.connect("body_entered", self, "_on_Area2D_body_entered")
	_area.connect("body_exited", self, "_on_Area2D_body_exited")


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		body.start_blink(true)


func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	if body is Player:
		body.stop_blink()
