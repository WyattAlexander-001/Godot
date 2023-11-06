extends Position2D

export (PackedScene) var spawnling_scene


func spawn() -> Node2D:
	var spawnling: Node2D = spawnling_scene.instance()
	spawnling.set_as_toplevel(true)
	spawnling.global_position = global_position
	add_child(spawnling)
	return spawnling
