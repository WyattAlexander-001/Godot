extends GutTest


const PATH := "res://main_menu_demos.csv"

const Scenes = preload("../Scenes.gd")

var scenes_metadata := Scenes.load_scenes_metadata(PATH)


func test_scene(scene_metadata = use_parameters(scenes_metadata)) -> void:
	assert_file_exists(scene_metadata.path)
	assert_true(load(scene_metadata.path) is PackedScene, "[%s] should be a PackedScene." % [scene_metadata.path])
