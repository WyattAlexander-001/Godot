extends PracticeTests

const MAX_POSITION := Vector2.ONE * 500.0


func _init() -> void:
	add_requirement(".", [], ["calculate_random_position", "generate_gems_at_random_positions"])


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")

func test_function_returns_random_vector() -> String:
	var pos: Vector2 = scene_root.calculate_random_position(MAX_POSITION)
	var sus_factor := 0
	var max_sus_factor := 2
	for _i in 100:
		var new_pos: Vector2 = scene_root.calculate_random_position(MAX_POSITION)

		if pos.is_equal_approx(new_pos):
			if sus_factor > max_sus_factor:
				return tr("We're getting similar vectors from `calculate_random_position`. Did you use randf()?")
			else:
				sus_factor += 1
		if is_equal_approx(pos.x, new_pos.x):
			if sus_factor > max_sus_factor:
				return tr("We're getting similar x values from `calculate_random_position`. Did you use randf() for both axes?")
			else:
				sus_factor += 1
		if is_equal_approx(pos.y, new_pos.y):
			if sus_factor > max_sus_factor:
				return tr("We're getting similar y values from `calculate_random_position`. Did you use randf() for both axes?")
			else:
				sus_factor += 1
		if is_equal_approx(new_pos.x, new_pos.y):
			if sus_factor > max_sus_factor:
				return tr("The gems seem to have equal X and Y positions. Did you make a Vector2 and called randf() twice, once for the X axis, and once for the Y axis?")
			else:
				sus_factor += 1
		pos = new_pos
	return ""

func test_function_outputs_random_positions_within_max_offset() -> String:
	scene_root.generate_gems_at_random_positions(100, MAX_POSITION)
	var rect := Rect2(Vector2.ZERO, MAX_POSITION + Vector2.ONE)
	var gems_bbox := Rect2(Vector2.INF, Vector2.ZERO)
	for child in scene_root.get_children():
		if not rect.has_point(child.position):
			return (
				tr(
					"We expected all generated gems to be at random positions within %s but we found one sprite at position %s. Did you use max_offset in calculate_random_position()?"
				)
				% [rect, MAX_POSITION]
			)
		gems_bbox.position.x = min(child.position.x, gems_bbox.position.x)
		gems_bbox.position.y = min(child.position.y, gems_bbox.position.y)
		gems_bbox.size.x = max(child.position.x, gems_bbox.size.x)
		gems_bbox.size.y = max(child.position.y, gems_bbox.size.y)

	if gems_bbox.size.is_equal_approx(Vector2.ZERO):
		return tr(
			"All the gems were generated at the same position. Did you generate random positions in the calculate_random_position() function?"
		)
	if gems_bbox.size.length() <= Vector2.ONE.length():
		return tr(
			"All the gems were placed within a 1 by 1 pixel rectangle. Did you take max_offset into account in calculate_random_position()?"
		)
	if gems_bbox.size < MAX_POSITION / 2:
		return tr(
			"It looks like the gems are very close together. Did you use `max_offset`?"
		)
	return ""
