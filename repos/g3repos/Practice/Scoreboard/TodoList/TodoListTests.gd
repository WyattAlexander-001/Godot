extends PracticeTests

const TodoItem := preload("TodoItem.gd")


func _init() -> void:
	add_requirement(".", ["line_edit"], ["add_todo"])


func _prepare_async():
	._prepare_async()
	randomize()
	yield(get_tree().create_timer(1.0), "timeout")


func test_calling_add_todo_adds_todo_item() -> String:
	var text := "Test todo item %s" % [randi() % 100]
	scene_root.add_todo(text)
	for child in scene_root.get_children():
		if child is TodoItem:
			if child.label.text == text:
				return ""
	return tr(
		"We tried adding a TodoItem by calling add_todo() but none was added. Did you instance TodoItem.tscn and add it as a child of the TodoList node with the add_child() function?"
	)


func test_pressing_button_adds_todo_item() -> String:
	var text := "Test todo item %s" % [randi() % 100]
	var button: Button = scene_root.get_node("HBoxContainer/Button")
	var line_edit: LineEdit = scene_root.get_node("HBoxContainer/LineEdit")
	line_edit.text = text
	button.emit_signal("pressed")
	for child in scene_root.get_children():
		if child is TodoItem:
			if child.label.text == text:
				return ""
	return tr(
		"When we tried pressing the button, nothing happening. Did you forget to connect the button's signal? Or did you not call add_todo() from the signal callback function?"
	)


func test_pressing_button_clears_the_todo_field() -> String:
	if scene_root.line_edit.text != "":
		return tr("When pressing the button, the line edit node is not emptied. Did you forget to connect the button's signal?")
	return ""
