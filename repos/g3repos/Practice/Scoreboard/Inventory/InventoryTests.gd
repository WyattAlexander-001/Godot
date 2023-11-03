extends PracticeTests

const InventoryItem := preload("InventoryItem.gd")

func _init() -> void:
	add_requirement(".", [], ["add_inventory_item"])


func _prepare_async():
	._prepare_async()
	randomize()
	yield(get_tree().create_timer(1.0), "timeout")


func test_code_preloads_InventoryItem_scene() -> String:
	if not matches_code_line_regex(["preload\\(.*InventoryItem\\.tscn('|\")\\)"]):
		return tr("We expected your code call the preload() function and to load InventoryItem.tscn. Did you call the preload() function?")
	return ""


func test_is_using_instantiation() -> String:
	if not matches_code_line(["*.instance()*"]):
		return tr("We expected your code to call the instance() function on a preloaded scene but couldn't find this call. Did you call instance()?")
	return ""


func test_is_using_add_child() -> String:
	if not matches_code_line(["add_child(*)"]):
		return tr("We expected your code to call the add_child() function but couldn't find it. Did you call add_child()?")
	return ""


func test_inventory_has_25_children() -> String:
	var count := scene_root.get_child_count()
	if count != 25:
		return tr("We expected 25 InventoryItem instances, but we found %s. Did you add InventoryItem instances as children of the Inventory?") % [count]
	return ""


func test_all_childrens_are_instance_of_InventoryItem() -> String:
	var child_count := scene_root.get_child_count()
	if child_count == 0:
		return tr("You did not add any node as a child of the Inventory. Did you call add_child()? Or did you instantiate InventoryItem?")

	for i in child_count:
		var child = scene_root.get_child(i)
		if not (child is InventoryItem):
			return tr("Child %s is not an instance of InventoryItem. Did you add something other than an InventoryItem as a child of the Inventory?" % [i.name])
	return ""
