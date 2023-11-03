extends Node2D

export var speed := 0.1
onready var animation_player := $AnimationPlayer

func _ready():
	animation_player.playback_speed = speed
