# Loads and saves UserProfile resources.
#
# We separated the UserProfile resource from this node to be able to register
# this class as an autoload and use it as a proxy to mark done practices from
# running scenes.
extends Node

const UserProfile := preload("UserProfile.gd")

const FILE_PATH := "user://progress.tres"

var _loaded_profile: UserProfile


func setup(course: Course) -> void:
	if ResourceLoader.exists(FILE_PATH):
		_load(false, course)
	else:
		_create(course)


func mark_complete(practice_script_file_path: String) -> void:
	if ResourceLoader.exists(FILE_PATH):
		_load()
	_loaded_profile.mark_complete(practice_script_file_path)
	save()


func mark_incomplete(practice_name: String) -> void:
	if ResourceLoader.exists(FILE_PATH):
		_load()
	_loaded_profile.mark_incomplete(practice_name)
	save()


# Saves the user file to the user's user:// directory.
func save() -> void:
	if not _loaded_profile:
		printerr("Can't save profile as no profile was created or loaded first.")
		return
	ResourceSaver.save(FILE_PATH, _loaded_profile)


func get_completed_practices() -> Array:
	if not _loaded_profile:
		return []

	var out := []
	for practice_name in _loaded_profile.profile_data:
		if _loaded_profile.profile_data[practice_name].completed:
			out.append(practice_name)
	return out


func erase_progress() -> void:
	for practice_name in _loaded_profile.profile_data:
		_loaded_profile.profile_data[practice_name].completed = false
	save()


func _create(course_data: Course) -> void:
	if _loaded_profile:
		printerr("Trying to create profile '%s' but it already exists.", FILE_PATH)
		return

	_loaded_profile = UserProfile.new()
	_loaded_profile.update_practices_list(course_data)
	save()


# Loads the existing user profile from the disk.
# Pass in the practices data loaded from the "database" to update the student's
# profile.
func _load(force_reload := false, course_data: Course = null) -> void:
	if not ResourceLoader.exists(FILE_PATH):
		printerr("Trying to load nonexistent user profile file: " + FILE_PATH)
		return
	_loaded_profile = ResourceLoader.load(FILE_PATH, "", force_reload)
	print("Loaded user profile from '%s'" % FILE_PATH)
	if course_data:
		var difference := course_data.get_practice_count() - _loaded_profile.profile_data.size()
		var is_version_outdated := _loaded_profile.version < _loaded_profile.CURRENT_VERSION

		if is_version_outdated:
			_loaded_profile.version = _loaded_profile.CURRENT_VERSION

		if difference != 0 or is_version_outdated:
			var verb := "Removing" if difference < 0 else "Adding"
			var preposition := "from" if difference < 0 else "to"
			print("Updating user profile. %s %s new practices %s save file." % [verb, abs(difference), preposition])
			_loaded_profile.update_practices_list(course_data)
			save()
