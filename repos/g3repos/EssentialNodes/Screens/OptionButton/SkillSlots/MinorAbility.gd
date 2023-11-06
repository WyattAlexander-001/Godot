extends TextureRect

const TEXTURE_UNLOCKED := preload("res://common/UI/boost_filled_center.png")
const TEXTURE_LOCKED := preload("res://common/UI/boost_empty.png")

onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	texture = TEXTURE_LOCKED


func purchase() -> void:
	texture = TEXTURE_UNLOCKED
	_animation_player.play("bounce")


func is_available() -> bool:
	return texture == TEXTURE_LOCKED
