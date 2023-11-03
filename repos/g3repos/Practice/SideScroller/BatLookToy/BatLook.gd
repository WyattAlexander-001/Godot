extends Sprite

# Stores the bat textures in an array for easy access.
var bat_textures := [
	preload("bat_aware.png"),
	preload("bat_hang.png")
]

onready var look_direction := $LookDirection
