# Uses functions to find and load resources in the project, and exposes those 
# resources to other parts of the game for procedural generation.
extends Node

const PICKUP_TILE_ID := 0
const ENEMY_TILE_ID := 1

var pickups := _load_resources(_find_scenes_in_directory("res://pickups"))
var enemies := _load_resources(_find_scenes_in_directory("res://enemies"))
var rooms := _load_resources(_find_scenes_in_directory("res://levels/rooms"))
var weapons := _load_resources(_find_scenes_in_directory("res://spells"))

# We use a Dictionary to look up the tile index on each of the Tilemap's tiles.
var scenes_map := {
	PICKUP_TILE_ID: pickups,
	ENEMY_TILE_ID: enemies,
}


static func _load_resources(file_paths: Array) -> Array:
	var resources := []
	for path in file_paths:
		resources.append(load(path))
	return resources


static func _find_scenes_in_directory(directory_path: String) -> Array:
	return _find_files_in_directory(directory_path, ".tscn")


static func _find_files_in_directory(directory_path: String, file_extension: String) -> Array:
	var files := []
	var directory := Directory.new()

	var can_continue := directory.open(directory_path) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [directory_path])
		return []

	var filename_pattern := "*" + file_extension
	directory.list_dir_begin(true, true)
	var file_name := directory.get_next()
	while file_name != "":
		if not directory.current_is_dir() and file_name.match(filename_pattern):
			files.append(directory_path.plus_file(file_name))
		file_name = directory.get_next()

	return files
