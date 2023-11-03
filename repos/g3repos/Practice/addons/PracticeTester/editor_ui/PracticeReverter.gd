# Reverts a practice to its starting state by erasing files and copying the
# original to the practice directory.
tool
extends Reference

const ADDON_DIRNAME := "PracticeTester"

var addon_directory := get_addon_directory(get_script().resource_path)
var source_directory := addon_directory.plus_file("practices_copy")

var _dir := Directory.new()


func get_addon_directory(file_path: String) -> String:
	var directory := get_parent_directory(file_path)
	while directory != "res://":
		if directory.get_file() == ADDON_DIRNAME:
			return directory
		directory = get_parent_directory(directory)
	return ""


static func get_parent_directory(resource_path: String) -> String:
	return resource_path.plus_file("..").simplify_path()


# Erases all files in the practice directory and replaces them with the source
# files.
# Returns true if the operation succeeded.
func revert(practice_scene_path: String) -> bool:
	var scene_directory := get_parent_directory(practice_scene_path)
	if not _dir.dir_exists(scene_directory):
		printerr("Directory '%s' does not exist. Can't revert practice files." % scene_directory)
		return false

	var scene_dirname := scene_directory.get_file()
	var copy_source_directory := source_directory.plus_file(scene_dirname)
	if not _dir.dir_exists(copy_source_directory):
		printerr(
			(
				"Source directory '%s' does not exist. Can't copy original practice files. Is the practice build state up to date?"
				% scene_directory
			)
		)
		return false
	
	var success := false
	success = _delete_godot_files_recursively(scene_directory)
	if not success:
		return false
	success = _copy_files_recursive(copy_source_directory, scene_directory)
	return success


# Recursively deletes all GDScript, tscn, and tres files and sub-directories in
# `dirpath`. Returns true if the operation succeeded.
func _delete_godot_files_recursively(dirpath: String) -> bool:
	var directory := Directory.new()
	if not directory.dir_exists(dirpath):
		printerr("Directory '%s' does not exist. Can't delete its contents.'" % dirpath)
		return false

	var error := directory.open(dirpath)
	if error != OK:
		printerr("Failed to open directory '%s'. Can't delete its contents." % dirpath)
		return false

	directory.list_dir_begin(true, true)
	var file_name := directory.get_next()
	while file_name != "":
		var extension := file_name.get_extension()
		if not extension in ["tscn", "tres", "gd", "res", "theme"]:
			file_name = directory.get_next()
			continue

		var path := dirpath.plus_file(file_name)
		if directory.current_is_dir():
			# Recursively delete all files and sub-directories as we can only
			# delete an empty directory or a single file with Directory.remove()
			_delete_godot_files_recursively(path)
		directory.remove(path)
		file_name = directory.get_next()
	return true


# Copies the contents of `source_directory` to `destination_directory`
# recursively, recreating the folder structure as needed.
#
# Ignores existing files and sub-directories to avoid file access errors when
# reverting practices with image files and other imported resources.
#
# Returns true if the operation succeeded.
func _copy_files_recursive(source_directory: String, destination_directory: String) -> bool:
	var directory := Directory.new()
	var error := directory.open(source_directory)
	if error != OK:
		printerr("Failed to open directory '%s'. Can't copy its contents." % source_directory)
		return false

	directory.list_dir_begin(true, true)
	var file_name := directory.get_next()
	while file_name != "":
		var target := destination_directory.plus_file(file_name)
		if directory.file_exists(target) or directory.dir_exists(target):
			file_name = directory.get_next()
			continue

		var source := source_directory.plus_file(file_name)
		if directory.current_is_dir():
			directory.make_dir(source)
			_copy_files_recursive(source, target)
		else:
			directory.copy(source, target)

		file_name = directory.get_next()
	return true
