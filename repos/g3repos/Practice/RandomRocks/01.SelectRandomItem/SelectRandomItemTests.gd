extends PracticeTests

var items := []
var are_items_from_ITEMS_const := false
var are_items_random := false


func _init() -> void:
	add_requirement(".", ["ITEMS"], ["get_random_item"])
	add_requirement("GridContainer")

func _prepare_async():
	._prepare_async()
	yield(tree.create_timer(0.8), "timeout")

	randomize()
	for i in 10:
		var item: Dictionary = scene_root.get_random_item()
		if scene_root.ITEMS.find(item) == -1:
			return
		items.append(item)
	are_items_from_ITEMS_const = true

	var unique_items := []
	for item in items:
		if not item in unique_items:
			unique_items.append(item)
	are_items_random = unique_items.size() != 1
	
	var grid_container := scene_root.get_node("GridContainer")
	for item in items:
		var ui_item := preload("items/UIItem.tscn").instance()
		grid_container.add_child(ui_item)
		ui_item.setup(item)
		yield(tree.create_timer(0.1), "timeout")


func test_function_returns_random_item() -> String:
	if not are_items_from_ITEMS_const:
		return tr(
			(
				"When we tried to get a random item, we got a value that does not exist in the ITEMS array: %s."
				% items.front()
			)
		)

	if not are_items_random:
		return tr(
			(
				"We expected to get random items but when calling get_random_item(), we always got the same value: %s."
				% items.front()
			)
		)
	return ""


func test_function_uses_randi() -> String:
	if not matches_code_line(["*ITEMS[randi()*]", "*randi()%ITEMS.size()*"]):
		return tr(
			"Your could should use the randi() function to get a random index from the ITEMS array but we couldn't find this code. Did you call the randi() function?"
		)
	return ""
