extends Control

const ITEMS := [
	preload("items/Boomerang.tres"),
	preload("items/Sword.tres"),
	preload("items/Wand.tres")
]

const Item := preload("Item.gd")

onready var ui_inventory := $UIInventory
onready var save_button := $Panel/HBoxContainer/SaveButton
onready var add_button := $Panel/HBoxContainer/AddItemButton
onready var remove_item_button := $Panel/HBoxContainer/RemoveItemButton


func _ready() -> void:
	save_button.connect("pressed", self, "_on_SaveButton_pressed")
	add_button.connect("pressed", self, "_on_AddItemButton_pressed")
	remove_item_button.connect("pressed", self, "_on_RemoveItemButton_pressed")
	

func _on_SaveButton_pressed() -> void:
	var inventory = ui_inventory.inventory
	if not inventory:
		return
	if not inventory.has_method("save"):
		return
	inventory.save()


func _on_AddItemButton_pressed() -> void:
	if not ui_inventory.inventory:
		return
	var item_model : Item = ITEMS[randi() % ITEMS.size()]
	var item = item_model.duplicate()
	ui_inventory.inventory.items.append(item)
	ui_inventory.update_items_display()


func _on_RemoveItemButton_pressed() -> void:
	if not ui_inventory.inventory:
		return
	ui_inventory.inventory.items.pop_back()
	ui_inventory.update_items_display()
