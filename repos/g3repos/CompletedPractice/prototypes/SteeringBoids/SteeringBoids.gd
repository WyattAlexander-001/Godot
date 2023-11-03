extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_random_ships()


func spawn_random_ships() -> void:
	for i in int(rand_range(3, 8)):
		var animal := preload("SteeringBoid.tscn").instance()
		animal.position = Vector2(
			rand_range(-50, 50),
			rand_range(-50, 50)
		)
		add_child(animal)
