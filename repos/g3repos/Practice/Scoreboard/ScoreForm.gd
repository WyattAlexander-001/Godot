extends Control

onready var scoreboard := $Scoreboard
onready var name_field := $HBoxContainer/NameField
onready var points_field := $HBoxContainer/PointsField


func _on_OkButton_pressed() -> void:
	# If either field contains no text, we stop the function.
	if not name_field.text or not points_field.text:
		return

	scoreboard.show()
	scoreboard.add_row(name_field.text, points_field.text)
	name_field.text = ""
