const SCENE_EXTENSION := ".tscn"
const TEST_SCRIPT_END := "Tests.gd"


static func find_scenes_and_tests(path: String = "res://", ignore: Array = ["res://addons"]) -> Array:
	var result := []
	var dir := Directory.new()

	if dir.open(path) != OK:
		printerr("ERROR: could not open [%s]" % [path])
		return result

	if dir.list_dir_begin(true, true) != OK:
		printerr("ERROR: could not list contents of [%s]" % [path])
		return result

	path = dir.get_next()
	while path != "":
		path = dir.get_current_dir().plus_file(path)
		if dir.current_is_dir() and not dir.get_current_dir() in ignore:
			result += find_scenes_and_tests(path)
		elif path.ends_with(TEST_SCRIPT_END):
			result.push_back({"scene_path": path.replace(TEST_SCRIPT_END, SCENE_EXTENSION), "test_path": path})
		path = dir.get_next()

	return result
