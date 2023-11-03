extends Node2D

const Inventory = preload("Inventory.gd")

export var inventory: Resource setget set_inventory

onready var right_hand_weapon := $Robot/RightHand
onready var right_hand_anim := $Robot/RightHand/AnimationPlayer
onready var left_hand_weapon := $Robot/LeftHand
onready var left_hand_anim := $Robot/LeftHand/AnimationPlayer


func set_inventory(new_inventory: Resource) -> void:
	assert(new_inventory == null or new_inventory is Inventory, "inventory property needs to be an instance of Inventory")
	if inventory != new_inventory:
		inventory = new_inventory
		if inventory:
			# make sure to connect the inventory to the correct functions here
			pass
	
	
func _on_Inventory_left_hand_changed() -> void:
	if inventory:
		if inventory.left_hand_weapon:
			left_hand_weapon.texture = inventory.left_hand_weapon.icon_texture
			left_hand_anim.play("show")
		else:
			left_hand_weapon.texture = null


func _on_Inventory_right_hand_changed() -> void:
	if inventory:
		if inventory.right_hand_weapon:
			right_hand_weapon.texture = inventory.right_hand_weapon.icon_texture
			right_hand_anim.play("show")
		else:
			right_hand_weapon.texture = null
