extends HBoxContainer

# We first get the two label nodes and store them with onready variables.
onready var points_label := $PointsLabel
onready var name_label := $NameLabel


# For each of the labels, we define a function that we will call from the
# scoreboard.
func set_player_points(points_value: String) -> void:
	# The function String.pad_zeros() adds zeros in front of the score to make
	# every score the same size. In this case, 6 digits.
	points_label.text = points_value.pad_zeros(6)


func set_player_name(player_name: String) -> void:
	name_label.text = player_name
