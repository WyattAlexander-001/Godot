extends Node2D

onready var animation_player: AnimationPlayer = $CanvasLayer/ColorRect/AnimationPlayer
onready var player: KinematicBody2D = $PlayerSideScroll


func _on_BlackHole_body_entered(_body: PhysicsBody2D) -> void:
	animation_player.play("fade_out")
	yield(animation_player, "animation_finished")
	
	player.position = Vector2(524, 484)
	animation_player.play("fade_in")
