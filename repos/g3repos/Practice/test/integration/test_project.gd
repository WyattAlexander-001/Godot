extends GutTest


func test_project_main_scene_empty() -> void:
	var setting_is_unset := not ProjectSettings.has_setting("application/run/main_scene")
	var setting_is_empty = ProjectSettings.get_setting("application/run/main_scene") == ""
	
	assert_true(setting_is_unset or setting_is_empty, "Your project's main scene should be empty or unset")
