extends PracticeTests

var properties := {"display_name": TYPE_STRING, "description": TYPE_STRING, "amount": TYPE_INT, "icon_texture": TYPE_OBJECT}

func _init() -> void:
	add_requirement(".", ["items"], ["update_items_display", "_on_tooltip_requested"])
	add_requirement("UITooltip")
	add_requirement("ItemGrid")
	add_requirement("UIDraggedItemPreview")


func _prepare_async():
	yield(get_tree(), "idle_frame")
	code = _preprocess_code(InventoryItem)
	yield(get_tree().create_timer(0.5), "timeout")


func test_items_exist() -> String:
	var item_count: int = scene_root.items.size()
	if item_count == 0:
		return tr("We found no resources in the items array.")
	for idx in scene_root.items.size():
		var item = scene_root.items[idx]
		if not item is InventoryItem:
			return tr("Item %s in the inventory isn't an instance of InventoryItem")%[idx+1]
	return ""

func test_there_are_enough_items() -> String:
	var minimum_items := 3
	if scene_root.items.size() < minimum_items:
		return tr("There are less than %s items in the list")%[minimum_items]
	return ""


func test_item_class_has_proper_properties() -> String:
	var item := InventoryItem.new()
	var match_patterns := []
	var property_list := item.get_property_list()
	var found_count := 0

	for resource_property in property_list:
		var name: String = resource_property.name
		if not name in properties:
			continue

		if properties[name] != resource_property.type:
			return tr("It seems the property `%s` is not of the correct type. Did you set all your types correctly?")%[name]
		found_count += 1
		var match_string = "export*var*%s*" % [name]
		match_patterns.append(match_string)

	if not matches_code_line(match_patterns):
		return tr("It seems you didn't export all the properties.")

	if found_count != properties.size():
		return tr("We expected to find %s properties in InventoryItem, are you sure you created all the properties?")%[properties.size()]
	return ""
	
func test_items_have_data() -> String:
	var item_count: int = scene_root.items.size()
	if item_count == 0:
		return tr("There are no items in the array, so we can't test their data.")
	for idx in scene_root.items.size():
		var item = scene_root.items[idx]
		var message: String = tr("Item %s in the inventory isn't an instance of InventoryItem")%[idx+1]
		if not item is InventoryItem:
			return message
		for prop in properties:
			if (not (prop in item)) or (not item[prop]):
				return tr("Item %s's `%s` is unset or empty. Did you set all properties?")%[idx+1, prop]
	return ""
