extends PanelContainer

onready var scores_column := $MarginContainer/VBoxContainer/ScoresColumn


func add_row(player_name: String) -> void:
	var row := Label.new()
	row.text = player_name
	scores_column.add_child(row)


func _on_HideButton_pressed() -> void:
	hide()
