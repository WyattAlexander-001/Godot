extends MarginContainer

onready var map_size_button: OptionButton = $VBoxContainer/MapSize/MapSizeOptionButton
onready var mode_button: OptionButton = $VBoxContainer/GameMode/ModeOptionButton
onready var map_button: OptionButton = $VBoxContainer/Map/MapOptionButton


func _ready() -> void:
	# We map buttons to game customization options.
	var map := {
		mode_button: ["free for all", "team deathmatch", "king of the hill"],
		map_button: ["asteroid belt", "titan", "dune"],
		map_size_button: ["small", "medium", "large"],
	}
	# This allows us to populate the option lists in code.
	for button in map:
		for item in map[button]:
			button.add_item(item)
