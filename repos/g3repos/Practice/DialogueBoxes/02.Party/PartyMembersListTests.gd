extends PracticeTests

const members = preload("PartyMembersList.gd").members


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(1.0), "timeout")


func test_correct_party_is_created() -> String:
	if scene_root.get_child_count() < members.size():
		return tr("The PartyMembers node has fewer children than there are party members in the members array. Did you forget to iterate over the entire array?")

	for child in scene_root.get_children():
		var label := child.get_node("Label") as Label
		var texture := (child.get_node("PanelContainer/TextureRect") as TextureRect).texture
		var index := (child as Node).get_index()
		var member = members[index]
		print(label.text)
		if label.text != member.name or texture != member.texture:
			return tr("It seems some members are not set")
	return ""
