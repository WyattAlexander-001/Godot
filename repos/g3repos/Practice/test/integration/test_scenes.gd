extends GutTest


const Scenes = preload("../Scenes.gd")

var scenes_and_tests := Scenes.find_scenes_and_tests()


func test_load_scene(scene_and_test = use_parameters(scenes_and_tests)) -> void:
	assert_file_exists(scene_and_test.scene_path)
	assert_true(load(scene_and_test.scene_path) != null, "expected scene [%s] to load." % [scene_and_test.scene_path])


func test_run_tests(scene_and_test = use_parameters(scenes_and_tests)) -> void:
	var test: PracticeTests = load(scene_and_test.test_path).new()
	var scene: Node = load(scene_and_test.scene_path).instance()
	test.setup(scene)
	add_child_autoqfree(scene)
	add_child_autoqfree(test)

	if not test.required_input_actions.empty():
		pass_test("Skipping [%s] because it has [required_input_actions: %s]..." % [scene_and_test.test_path, test.required_input_actions])
		return

	var test_function_state: GDScriptFunctionState = test.run_tests_async()
	yield(yield_to(test_function_state, "completed", 5), YIELD)
	assert_signal_emitted(test_function_state, "completed")
