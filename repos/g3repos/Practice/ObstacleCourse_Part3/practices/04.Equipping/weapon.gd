extends Sprite

const Inventory := preload("Inventory.gd")

export(Resource) var inventory setget set_inventory

func _ready() -> void:
	_on_inventory_changed()

func set_inventory(new_inventory: Resource) -> void:
	assert(new_inventory == null or new_inventory is Inventory)
	if inventory != new_inventory:
		inventory = new_inventory
		inventory.connect("changed", self, "_on_inventory_changed")
	
	
func _on_inventory_changed() -> void:
	if inventory and inventory.items.size():
		texture = inventory.items[0].icon_texture
	else:
		texture = null
