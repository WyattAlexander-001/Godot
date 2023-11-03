extends PanelContainer

onready var scores_column := $MarginContainer/VBoxContainer/ScoresColumn


func _ready() -> void:
	add_row("Athos")
	add_row("Portos")
	add_row("Aramis")


func add_row(player_name: String) -> void:
	var row := Label.new()
	row.text = player_name
	# We want to add the row in our ScoresColumn, so we call add_child() on the
	# ScoresColumn node.
	scores_column.add_child(row)
