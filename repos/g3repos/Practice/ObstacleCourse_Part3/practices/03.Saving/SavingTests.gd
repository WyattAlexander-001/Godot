extends PracticeTests

const Inventory = preload("Inventory.gd")
const Item = preload("Item.gd")

onready var inventory: Inventory = scene_root.get_node("UIInventory").inventory

var has_save_function := false

func _init() -> void:
	add_requirement(".", [], ["_on_SaveButton_pressed", "_on_AddItemButton_pressed", "_on_RemoveItemButton_pressed"])
	add_requirement("UIInventory")
	add_requirement("Panel/HBoxContainer/SaveButton", [], [], ["pressed"])
	add_requirement("Panel/HBoxContainer/AddItemButton", [], [], ["pressed"])
	add_requirement("Panel/HBoxContainer/RemoveItemButton", [], [], ["pressed"])


func _prepare_async():
	yield(get_tree(), "idle_frame")
	code = _preprocess_code(Inventory)
	yield(get_tree().create_timer(0.5), "timeout")


func test_saving_function_exists() -> String:
	if not inventory.has_method("save"):
		return tr("There's no save() function on the inventory. Did you create the proper function?")
	return ""

func test_saving_function_works() -> String:
	if not inventory.has_method("save"):
		return tr("As there's no save() function, we can't test if it works.")

	var save_path := "user://inventory.tres"
	var test_inventory := Inventory.new()
	test_inventory.resource_path = save_path
	test_inventory.take_over_path(save_path)
	var dir := Directory.new()
	if dir.file_exists(save_path):
		dir.remove(save_path)
	var item := Item.new()
	item.display_name = "test"
	test_inventory.items.append(item)
	test_inventory.save()
	if dir.file_exists(save_path):
		dir.remove(save_path)
	else:
		return tr("We tried saving an inventory, but it didn't save. Are you sure you wrote the save function correctly and used the proper path?")
	return ""
