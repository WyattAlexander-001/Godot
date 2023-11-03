extends Control

onready var scoreboard := $Scoreboard
onready var name_field := $HBoxContainer/NameField


func _on_OkButton_pressed() -> void:
	scoreboard.add_row(name_field.text)
	scoreboard.show()
	name_field.text = ""
