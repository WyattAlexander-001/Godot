extends Node2D


func _ready() -> void:
	randomize()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if not enemy.is_in_group("visible"):
				continue
			enemy.die()
