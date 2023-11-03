extends "res://addons/MainMenu/DemoMenu.gd"

const SceneMetadata := preload("res://addons/MainMenu/SceneMetadata.gd")


func _ready() -> void:
	_main_menu.setup(load_scenes_data())


# Loads the demos' csv file and returns the array of SceneMetadata demos to display.
func load_scenes_data() -> Array:
	var scenes_metadata := []
	var file := File.new()
	var path := "res://main_menu_demos.csv"

	var error_code := file.open(path, File.READ)
	if error_code != OK:
		printerr("Error opening file %s, unable to load data from CSV table." % path)
		return []

	var header := file.get_csv_line()
	while not file.eof_reached():
		var line := file.get_csv_line()
		if line.size() < 2:
			break

		scenes_metadata.append(SceneMetadata.new(line[0], line[1], line[2], line[3]))
	return scenes_metadata
