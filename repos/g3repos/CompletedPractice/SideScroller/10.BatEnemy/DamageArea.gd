extends Area2D


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(player: KinematicBody2D) -> void:
	# A quick and easy way to reset the running scene.
	get_tree().reload_current_scene()
