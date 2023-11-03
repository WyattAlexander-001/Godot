extends PanelContainer

# This dictionary uses player names as keys and their max score as the value.
var player_scores = {
	"Scrooge McDuck": 99999,
	"Magicka De Spell": 700,
	"Gyro Gearloose": 200,
	"Daisy Duck": 120,
}

onready var scores_column := $MarginContainer/VBoxContainer/ScoresColumn


func _ready() -> void:
	for name in player_scores:
		add_row(name, str(player_scores[name]))


func add_row(player_name: String, player_points: String) -> void:
	var row := preload("ScoreRow.tscn").instance()
	scores_column.add_child(row)
	row.set_player_name(player_name)
	row.set_player_points(player_points)
	# If there's a key matching player_name in the dictionary, this line will
	# update the corresponding score. If there's no key matching player_name, it
	# will add an entry to the player_scores dictionary.
	player_scores[player_name] = player_points


func _on_HideButton_pressed() -> void:
	hide()
