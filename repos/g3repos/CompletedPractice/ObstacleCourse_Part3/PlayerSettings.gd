# Stores a player's input actions and customization options.
class_name PlayerSettings
extends Resource

export var move_up_action := "move_up"
export var move_down_action := "move_down"
export var move_left_action := "move_left"
export var move_right_action := "move_right"

export var color := Color.white
export var hand_texture: Texture = null setget set_hand_texture


func set_hand_texture(new_hand_texture: Texture) -> void:
	hand_texture = new_hand_texture
	# This Resource function is equivalent to calling emit_signal("changed").
	emit_changed()
