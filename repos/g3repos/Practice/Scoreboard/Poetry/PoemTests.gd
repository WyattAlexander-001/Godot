extends PracticeTests

const Poem := preload("Poem.gd")
const PoetryLine := preload("PoetryLine.gd")
const lines = Poem.lines


func _init() -> void:
	add_requirement(".", [], ["add_poetry_line"])


func _prepare_async():
	._prepare_async()
	randomize()
	yield(get_tree().create_timer(1.0), "timeout")


func test_calling_add_poetry_line_adds_a_poetry_line() -> String:
	var text := "Just add multiplayer, how hard can it be"
	scene_root.add_poetry_line(text)
	for child in scene_root.get_children():
		if child is PoetryLine:
			if child.label.text == text:
				return ""
	return tr(
		"We tried adding a PoetryLine by calling add_poetry_line() but none was added. Did you set the text properly on the PoetryLine scene instance?"
	)


func test_poem_is_entirely_added() -> String:
	for i in lines.size():
		var line_text = lines[i]
		var line_instance = scene_root.get_child(i)
		if line_instance.label.text != line_text:
			return tr("The line `%s` was not to the poem as intended. Did you set the text properly on the PoetryLine scene instance?") % line_text
	return ""
