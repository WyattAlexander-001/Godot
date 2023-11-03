# Resource used to save and load the players' inputs and character skins.
class_name SaveGame
extends Resource

# The file path of our save file. For player data, you must use the user://
# prefix, this will save the files to a special directory depending on the
# player's device.
const SAVE_GAME_PATH := "user://savegame.tres"

# We use the type Resource because we cannot export our own resource types in
# Godot 3.
export var player_1: Resource
export var player_2: Resource


func write_savegame() -> void:
	ResourceSaver.save(SAVE_GAME_PATH, self)


static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
