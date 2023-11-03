# A list of all chapters in the course. Each chapter contains a list of
# practices.
class_name Course
extends Resource

export var chapters := []


func load_completed(completed_practice_names := []) -> void:
	for chapter in chapters:
		for practice in chapter.practices:
			if practice.title in completed_practice_names:
				practice.completed = true


func get_practice_count() -> int:
	var count := 0
	for chapter in chapters:
		count += chapter.practices.size()
	return count
