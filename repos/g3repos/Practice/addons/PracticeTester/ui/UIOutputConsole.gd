extends "UIFoldablePanel.gd"

const UIErrorMessageScene := preload("UIErrorMessage.tscn")

onready var _scroll_container := $MarginContainer/VBoxContainer/ScrollContainer as ScrollContainer
onready var _message_list := $MarginContainer/VBoxContainer/ScrollContainer/MessageList as Control


# Removes all children
func clear_messages() -> void:
	if not is_inside_tree():
		return

	for message_node in _message_list.get_children():
		message_node.queue_free()


func print_error(text: String) -> void:
	if not is_inside_tree():
		return

	var message_node = UIErrorMessageScene.instance()
	_message_list.add_child(message_node)
	message_node.setup(text)
	yield(get_tree(), "idle_frame")
	_scroll_container.ensure_control_visible(message_node)
