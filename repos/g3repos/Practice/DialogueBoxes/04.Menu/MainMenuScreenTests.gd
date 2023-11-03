extends PracticeTests

const OptionsScene := preload("OptionsScreen.gd")
const CreditsScene := preload("../03.Credits/CreditsScreen.gd")


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(1.0), "timeout")


func test_options_button_pressed_signal_is_connected_to_show_screen() -> String:
	if not scene_root.options_button.is_connected("pressed", scene_root, "show_screen"):
		return tr("The options_button's pressed signal is not connected to the MainMenuScreen node. Did you call its connect() function?")
	return ""


func test_credits_button_pressed_signal_is_connected_to_show_screen() -> String:
	if not scene_root.credits_button.is_connected("pressed", scene_root, "show_screen"):
		return tr("The credits_button's pressed signal is not connected to the MainMenuScreen node. Did you call its connect() function?")
	return ""


func test_pressing_quit_button_quits_the_game() -> String:
	if not scene_root.quit_button.is_connected("pressed", get_tree(), "quit"):
		return tr("The quit_button's pressed signal is not connected to the SceneTree's quit() function. Did you call its connect() function? And did you call get_tree() to connect the button to the SceneTree?")
	return ""


func test_pressing_options_button_opens_options_screen() -> String:
	if not _does_button_runs_scene(scene_root.options_button, OptionsScene):
		return tr("Pressing the options_button should open the OptionsScene but it did not. Did you pass [OptionsScene] as the connect function's fourth argument?")
	return ""


func test_pressing_credits_button_opens_credits_screen() -> String:
	if not _does_button_runs_scene(scene_root.credits_button, CreditsScene):
		return tr("Pressing the credits_button should open the CreditsScene but it did not. Did you pass [CreditsScene] as the connect function's fourth argument?")
	return ""


func _does_button_runs_scene(button: Button, script: GDScript) -> bool:
	button.emit_signal("pressed")
	var child = scene_root.screens_container.get_child(0)
	if not child:
		scene_root.empty_screens()
		return false
	var given_script: GDScript = child.get_script()
	if not given_script:
		scene_root.empty_screens()
		return false
	var given_scene_path = given_script.resource_path
	scene_root.empty_screens()
	return given_scene_path == script.resource_path
