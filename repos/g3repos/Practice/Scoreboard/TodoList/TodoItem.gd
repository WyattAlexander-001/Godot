extends Control

onready var label := $HBoxContainer/Label


func set_text(new_text: String) -> void:
	# These two lines allow you to call the set_text() function before 
	# adding the poetry line as a child of the poem node.
	#
	# Yield() is a slightly more advanced feature that will learn towards the 
	# end of the course.
	if not is_inside_tree():
		yield(self, "ready")

	label.text = new_text
