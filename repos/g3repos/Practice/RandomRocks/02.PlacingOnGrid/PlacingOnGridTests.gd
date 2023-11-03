extends PracticeTests

var child_count := 0

func _init() -> void:
	add_requirement(".", [], ["generate_gems", "generate_one_gem"])


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")
	child_count = scene_root.get_child_count()


func test_function_generates_100_gems() -> String:
	if child_count != 100:
		return tr("We called 'generate_gems(10, 10)', so we expected to find 100 gems, but instead we found %s.") % child_count
	return ""


func test_gems_are_laid_on_a_10_by_10_grid() -> String:
	if child_count != 100:
		return tr("We don't have the expected number of gems, we can't test if they're laid in the expected 10 by 10 grid.")

	var previous_position := Vector2.ZERO
	var previous_cell := Vector2(-1, -1)
	for x in 10:
		for y in 10:
			var index: int = y + x * 10
			var sprite: Sprite = scene_root.get_child(index)
			if x > previous_cell.x and sprite.position.x < previous_position.x:
				return tr("Gem number %s appears to be placed to the left of gem %s, but we expected it to be on the right.") % [index, index - 1]
			if y > previous_cell.y and sprite.position.y < previous_position.y:
				return tr("Gem number %s appears to be placed above gem %s, but we expected it to be below it.") % [index, index - 1]

			previous_position = sprite.position
			previous_cell = Vector2(x, y)
	return ""
