tool
extends EditorPlugin

const UIpracticesDock := preload("editor_ui/UIPracticesDock.gd")
const UIPracticesDockScene := preload("editor_ui/UIPracticesDock.tscn")

const UserProfiles := preload("UserProfiles.gd")

var _dock: Control
var _profile := UserProfiles.new()

var _course: Course = null


func _enter_tree() -> void:
	add_autoload_singleton("UserProfiles", UserProfiles.resource_path)

	_course = _load_csv_data()
	_profile.setup(_course)
	_course.load_completed(_profile.get_completed_practices())

	_dock = UIPracticesDockScene.instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, _dock)

	_dock.setup(get_editor_interface(), _course)
	_dock.connect("reset_progress_confirmed", _profile, "erase_progress")
	_dock.connect("practice_state_reset", _profile, "mark_incomplete")


func _exit_tree() -> void:
	remove_autoload_singleton("UserProfiles")
	remove_control_from_docks(_dock)
	_course = null
	if _dock and is_instance_valid(_dock):
		_dock.queue_free()


# Loads the CSV file and turns its contents as a Course resource.
func _load_csv_data() -> Course:
	var _course := Course.new()
	var file := File.new()
	var path := _to_absolute_path("practices_meta.csv")

	var error_code := file.open(path, File.READ)
	if error_code != OK:
		printerr("Error opening file %s, unable to load data from CSV table." % path)
		return _course

	var header := file.get_csv_line()
	# Maps chapter name to an array of _course
	var data := {}
	while not file.eof_reached():
		var line := file.get_csv_line()
		if line.size() < 5:
			break

		var name: String = line[0]
		var chapter_name := line[4]
		if not chapter_name in data:
			data[chapter_name] = []
		var practice := Practice.new()
		practice.title = line[0]
		practice.path = line[1]
		practice.description = line[2]
		practice.tasks = line[3].split(";")
		if line[5] != "":
			practice.hints = line[5].split(";")
		practice.techniques = line[6]
		data[chapter_name].append(practice)

	for chapter_name in data:
		var chapter := Chapter.new()
		chapter.title = chapter_name.capitalize()
		chapter.practices = data[chapter_name]
		_course.chapters.append(chapter)

	return _course


func _to_absolute_path(relative_path: String) -> String:
	var this_directory: String = get_script().resource_path
	this_directory = this_directory.rsplit("/", true, 1)[0]
	return this_directory.plus_file(relative_path)
