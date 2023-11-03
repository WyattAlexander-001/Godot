extends PracticeTests

onready var player: KinematicBody2D = scene_root.get_node("Godot")
onready var player_sprite: Sprite = player.get("sprite")

var directions := {
	Vector2.LEFT: 0,
	Vector2.RIGHT: 0,
	Vector2.UP: 0,
	Vector2.DOWN: 0,
}

var current_direction := Vector2()


func _init() -> void:
	add_requirement("Godot/Sprite")


func _prepare_async():
	._prepare_async()
	var origin := player.position
	for direction in directions.keys():
		player.direction = direction
		yield(get_tree().create_timer(1), "timeout")
		directions[direction] = player.position.distance_to(origin)
		player.position = origin
	current_direction = Vector2()
	player.set_physics_process(false)
	set_physics_process(false)


func _verify_direction_was_blocked(direction_name: String, direction: Vector2) -> String:
	var distance: float = directions[direction]
	var expected := 200.0
	if distance > expected:
		return (
			tr(
				"When we moved in direction %s the character moved farther than expected. Are you sure the player has a collision shape?"
			)
			% [direction_name]
		)
	return ""


func test_player_has_collision_shape() -> String:
	var has_collider := false
	for child in player.get_children():
		if child is CollisionShape2D:
			has_collider = true
			if not child.shape:
				return tr(
					"Player has a CollisionShape2D node, but that node doesn't have a shape! Are you sure you set up the shape property?"
				)
	for child in player.get_children():
		if child is CollisionPolygon2D:
			has_collider = true
			return tr(
				"Player has a CollisionPolygon2D node. This can work, but is overkill for this exercise. Please replace it with a CollisionShape2D node!"
			)
	if not has_collider:
		return tr("The character does not have a collision shape. Did you add a CollisionShape2D node as a child of it?")
	return ""


func test_was_blocked_on_the_left() -> String:
	return _verify_direction_was_blocked("LEFT", Vector2.LEFT)


func test_was_blocked_on_the_right() -> String:
	return _verify_direction_was_blocked("RIGHT", Vector2.RIGHT)


func test_was_blocked_towards_top() -> String:
	return _verify_direction_was_blocked("UP", Vector2.UP)


func test_was_blocked_towards_bottom() -> String:
	return _verify_direction_was_blocked("DOWN", Vector2.DOWN)
