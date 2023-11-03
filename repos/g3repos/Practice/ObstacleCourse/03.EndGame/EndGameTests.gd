extends PracticeTests

var is_screen_visible_from_start := false

func _init() -> void:
	add_requirement(".", ["godot", "robot_statue"], ["_on_RobotStatue_body_entered"])
	add_requirement("RobotStatue")
	add_requirement("Godot")


func _prepare_async():
	._prepare_async()
	is_screen_visible_from_start = scene_root.finish_screen.visible
	yield(get_tree().create_timer(0.5), "timeout")


func get_collision_shape(node: Node) -> CollisionShape2D:
	var coll: CollisionShape2D
	for child in node.get_children():
		if child is CollisionShape2D:
			coll = child
	return coll


func test_statue_can_detect_godot() -> String:
	var statue_collider := get_collision_shape(scene_root.robot_statue)
	if not statue_collider or not statue_collider.shape:
		return tr(
			"The RobotStatue does not have a collision shape as a child. Did you add a CollisionShape2D node as a child of it? And did you assign it a Shape resource in the Inspector?"
		)

	if scene_root.godot.collision_layer & scene_root.robot_statue.collision_mask == 0:
		return tr(
			"The RobotStatue's collision mask does not target the collision layer on which the Godot node is, so it can't detect it. Please modify the RobotStatue's collision mask."
		)
	return ""


func test_godot_stops_when_touching_statue() -> String:
	scene_root._on_RobotStatue_body_entered(null)
	var is_processing: bool = scene_root.godot.is_physics_processing()
	scene_root.godot.set_physics_process(true)
	if is_processing:
		return tr(
			"When we simulated Godot touching the RobotStatue, Godot kept processing physics. Did you call set_physics_process() from _on_RobotStatue_body_entered() with a value of false?"
		)

	return ""

# hiding the screen right after showing it doesn't work, so we wait one frame
func _wait_and_hide_screen() -> void:
	yield(get_tree(), "idle_frame")
	scene_root.finish_screen.hide()
	scene_root.finish_screen.modulate = Color.white


func test_finish_screen_appears_when_touching_statue() -> String:
	if is_screen_visible_from_start:
		return tr("The FinishScreen node seems to be visible from the start. It should be hidden until the character touches the statue.")

	# the finish screen will flash for one frame, so we render it transparent
	scene_root.finish_screen.modulate = Color(0,0,0,0)
	scene_root._on_RobotStatue_body_entered(null)
	
	if not scene_root.finish_screen.visible:
		_wait_and_hide_screen()
		return tr("When we simulated Godot touching the RobotStatue, the FinishScreen did not appear. Did you make the finish screen visible?")
	_wait_and_hide_screen()
	return ""
