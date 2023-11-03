extends Node2D

onready var player_1 := $PlayerCharacter
onready var player_2 := $PlayerCharacter2


func _ready() -> void:
	player_1.settings = preload("../player_1_settings.tres")
	player_2.settings = preload("../player_2_settings.tres")
	player_1.settings.hand_texture = preload("../assets/hand_red_open.png")
