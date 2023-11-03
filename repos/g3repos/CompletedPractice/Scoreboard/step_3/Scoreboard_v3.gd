extends PanelContainer

onready var scores_column := $MarginContainer/VBoxContainer/ScoresColumn


# Note the addition of a new parameter: player points.
func add_row(player_name: String, player_points: String) -> void:
	# Loads the ScoreRow scene and creates a new instance of it.
	var row := preload("ScoreRow.tscn").instance()
	# We can add the ScoreRow instance as a child of the ScoresColumn like
	# plain nodes.
	scores_column.add_child(row)
	# As we instanced the ScoreRow scene, we can call the functions we defined
	# on it.
	row.set_player_name(player_name)
	row.set_player_points(player_points)


func _on_HideButton_pressed() -> void:
	hide()
