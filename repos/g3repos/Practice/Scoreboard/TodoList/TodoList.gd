extends VBoxContainer

onready var line_edit := $HBoxContainer/LineEdit


func add_todo(text: String) -> void:
	# Create an instance of the TodoItem scene, add it as a child, and set its text.
	var todo_item
	# Call the todo_item's set_text() function to change the displayed text.


func _on_Button_pressed() -> void:
	if line_edit.text:
		# Add a todo item with the correct text.
		pass
	line_edit.text = ""
