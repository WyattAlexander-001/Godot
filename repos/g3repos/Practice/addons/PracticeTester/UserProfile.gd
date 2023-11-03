# Stores the student's progress as a dictionary on the disk.
tool
extends Resource

# We use this file for the editor plugin to poll for new completed practices as
# we can't get that data from the resource directly when the student completes a
# practice.
const COMPLETED_PATH := "user://new_completed_practices.cache"
# Default version number for newly created resources.
const CURRENT_VERSION := 5

export var profile_data := {} setget set_profile_data
# Maps file paths to practice names.
export var practice_file_to_name := {}
# Increase this number when making changes to the resource's format or practices and
# detect when it needs updates.
export var version := CURRENT_VERSION

var _file := File.new()


func mark_complete(practice_file_path: String) -> void:
	practice_file_path = practice_file_path.replace(".gd", ".tscn")
	if not practice_file_to_name.has(practice_file_path):
		print_debug()
		printerr("Trying to mark nonexistent practice %s as complete" % practice_file_path)
		return

	var name: String = practice_file_to_name[practice_file_path]

	if not profile_data.has(name):
		print_debug()
		printerr("Trying to mark nonexistent practice '%s' as complete" % name)
		return

	# We don't want to mark as completed again if it already is as it causes to
	# create and poll a file to update the editor plugin UI.
	if profile_data[name].completed:
		return

	profile_data[name].completed = true
	var error := _file.open(COMPLETED_PATH, File.WRITE)
	if error != OK:
		printerr("Could not open file '%s' to read newly completed practices." % COMPLETED_PATH)
		return
	_file.store_line(name)
	_file.close()


func mark_incomplete(practice_name: String) -> void:
	if not profile_data.has(practice_name):
		print_debug()
		printerr("Trying to mark nonexistent practice '%s' as incomplete." % practice_name)
		return
	profile_data[practice_name].completed = false


func set_profile_data(new_data: Dictionary) -> void:
	profile_data = new_data
	for practice_name in profile_data:
		var scene_path: String = profile_data[practice_name].scene
		practice_file_to_name[scene_path] = practice_name


# Merges completed entries in profile_data with the new Practice entries.
func update_practices_list(course_data: Course) -> void:
	var completed_practices := []
	for practice_name in profile_data:
		if profile_data[practice_name].completed:
			completed_practices.append(practice_name)

	profile_data = {}
	practice_file_to_name = {}
	for chapter in course_data.chapters:
		for practice in chapter.practices:
			profile_data[practice.title] = {
				# TODO: check if removing the project key is OK
				scene = practice.path,
				completed = practice.title in completed_practices,
			}

			var scene_path: String = practice.path
			practice_file_to_name[scene_path] = practice.title
