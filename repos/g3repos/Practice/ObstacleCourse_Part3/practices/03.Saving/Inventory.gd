extends Resource

const Item = preload("Item.gd")

export(Array, Resource) var items := [] setget set_items

# Create a new function named save. It should save this resource at the correct path.
# To get the correct save file path, call the get_save_path() function.


# Returns the correct path to save the inventory resource.
func get_save_path() -> String:
	return resource_path.get_base_dir().plus_file("inventory.tres")


func set_items(new_items: Array) -> void:
	for index in new_items.size():
		var item = new_items[index]
		assert(item == null or item is Item, "Item %s is not an instance of InventoryItem"%[index])
	items = new_items
