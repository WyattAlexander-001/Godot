extends PracticeTests

const dialogue := preload("LinearDialogue.gd").dialogue

var are_portraits_correct := true
var are_names_correct := true


func _init() -> void:
	add_requirement(".", ["texture_rect", "name_label"], ["advance", "show_line"])


# Run through slides and compare to dialogue
func _prepare_async() -> void:
	var tree := get_tree()
	for index in dialogue.size():
		are_names_correct = are_names_correct and scene_root.name_label.text == dialogue[index].name
		are_portraits_correct = are_portraits_correct and scene_root.texture_rect.texture == dialogue[index].texture
		scene_root.advance()
		yield(tree.create_timer(0.7), "timeout")
		


func test_displays_correct_portraits() -> String:
	if not are_portraits_correct:
		return tr("The displayed character portraits do not match the textures loaded in the dialogue variable. Did you update the texture_rect's texture in show_line()?")
	return ""


func test_displays_correct_names() -> String:
	if not are_names_correct:
		return tr("The displayed character names do not match the names stored in the dialogue variable. Did you update the name_label's text in show_line()?")
	return ""
