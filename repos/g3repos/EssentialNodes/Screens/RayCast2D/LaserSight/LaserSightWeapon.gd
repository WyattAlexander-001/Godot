extends Node2D

onready var laser := $LaserBeam2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		laser.is_casting = true
	elif event.is_action_released("shoot"):
		laser.is_casting = false
