extends KinematicBody2D

onready var _sprite := $Sprite
onready var animation_player := $AnimationPlayer

func take_damage() -> void:
	animation_player.play("Die")
