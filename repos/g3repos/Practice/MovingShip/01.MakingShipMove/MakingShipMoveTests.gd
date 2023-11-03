extends PracticeTests


func _init() -> void:
	add_requirement(".", ["velocity"])


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(1.0), "timeout")


func test_velocity_is_not_zero() -> String:
	if scene_root.get("velocity").length_squared() < 0.1:
		return tr(
			"The velocity should have a higher length. Did you change the vector's arguments to make it longer?"
		)
	return ""


func test_position_changes_every_frame() -> String:
	var patterns := [
		"position+=*",
		"position=position+*",
		"position=*+position",
		"set_position(position+*)",
		"set_position(*+position)"
	]
	if not matches_code_line(patterns):
		return tr(
			"It seems the position is not changing every frame. Did you add the velocity times delta to the ship's position?"
		)
	return ""


func test_movement_takes_delta_into_account() -> String:
	if not matches_code_line_regex(["velocity.*\\*delta", "delta.*\\*velocity"]):
		return tr(
			"It seems you're not multiplying the velocity by delta. You need to do so to make movement time-dependent."
		)
	return ""
