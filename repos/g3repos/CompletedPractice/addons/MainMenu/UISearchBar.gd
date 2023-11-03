extends LineEdit


func _init() -> void:
	if not InputMap.has_action("focus_search_bar"):
		print_debug("Main menu search bar expects an input action named focus_search_bar. Creating one bound to Ctrl+F.")
		InputMap.add_action("focus_search_bar")
		var event := InputEventKey.new()
		event.scancode = KEY_F
		event.control = true
		InputMap.action_add_event("focus_search_bar", event)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("focus_search_bar"):
		grab_focus()
		accept_event()


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		text = ""
		emit_signal("text_changed", text)
