tool
extends Control

const images := [
	preload("assets/gem_fire.png"),
	preload("assets/gem_health.png"),
	preload("assets/gem_ice.png"),
	preload("assets/gem_lightning.png"),
	preload("assets/sword.png")
]
var count := images.size()

onready var label := $Label
onready var texture_rect := $TextureRect


func _ready() -> void:
	label.text = str(get_index() + 1).pad_zeros(2)
	texture_rect.texture = images[randi() % count]
