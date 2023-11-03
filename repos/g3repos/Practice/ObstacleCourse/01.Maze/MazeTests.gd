extends PracticeTests


func _init() -> void:
	add_requirement(".", ["godot", "statue", "wall"])
	add_requirement("Godot")
	add_requirement("RobotStatue")
	add_requirement("Walls/BrokenWall")
	add_requirement("Walls/BrokenWall/Sprite")


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")

func get_collision_shape(node: Node) -> CollisionShape2D:
	var coll: CollisionShape2D
	for child in node.get_children():
		if child is CollisionShape2D:
			coll = child
	return coll

func process_node(node: Node) -> String:
	var coll := get_collision_shape(node)
	var name := node.name
	if not coll:
		return tr("Node %s does not have a CollisionShape2D as a child. Please add a CollisionShape2D to the %s scene.") % [name, name]
	if not coll.shape:
		return tr("Node %s has a CollisionShape2D as a child but the node is lacking a shape. Please give it a shape using the Inspector.") % [name]
	if not coll.shape is RectangleShape2D:
		return tr("Node %s has a CollisionShape2D as a child but its shape isn't a RectangleShape2D. Please assign it a RectangleShape2D using the Inspector.") % [name]
	return ""


func test_wall_shape_is_a_rectangle() -> String:
	return process_node(scene_root.wall)


func test_statue_shape_is_a_rectangle() -> String:
	return process_node(scene_root.statue)


func test_godot_shape_is_a_rectangle() -> String:
	return process_node(scene_root.godot)


func test_wall_shape_encloses_the_wall_sprite() -> String:
	var coll := get_collision_shape(scene_root.wall)
	if not coll or not coll.shape or not coll.shape is RectangleShape2D:
		return tr("No RectangleShape2D found for the wall node. Can't test the shape's size.")

	var shape_rect := Rect2(coll.position - coll.shape.extents, coll.shape.extents * 2.0)
	var sprite := scene_root.wall.get_node("Sprite") as Sprite
	var sprite_rect = sprite.get_rect()
	sprite_rect.position += sprite.position

	if not shape_rect.encloses(sprite_rect):
		return tr("The wall's collision shape should enclose the wall sprite, but it does not. Did you make it big enough to be as large or larger than the sprite?")
	return ""

func test_statue_shape_encloses_the_base() -> String:
	var coll := get_collision_shape(scene_root.wall)
	if not coll or not coll.shape or not coll.shape is RectangleShape2D:
		return tr("No RectangleShape2D found for the wall node. Can't test the shape's size.")

	var shape_rect := Rect2(coll.position - coll.shape.extents, coll.shape.extents * 2.0)
	var statue_expected_rect := Rect2(Vector2(-50,-60), Vector2(100, 60))
	if not shape_rect.encloses(statue_expected_rect):
		return tr("The wall's collision shape should enclose the wall sprite, but it does not. Did you make it big enough to be as large or larger than the sprite?")
	return ""
