extends Resource

signal left_hand_changed
signal right_hand_changed
export(Array, Resource) var items := []

export var left_hand_weapon: Resource setget set_left_hand_weapon
export var right_hand_weapon: Resource setget set_right_hand_weapon


func set_left_hand_weapon(new_weapon: Resource) -> void:
	left_hand_weapon = new_weapon
	# emit the correct signal here
	pass


func set_right_hand_weapon(new_weapon: Resource) -> void:
	right_hand_weapon = new_weapon
	# emit the correct signal here
	pass
