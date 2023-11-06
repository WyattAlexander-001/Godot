extends Label


func _process(delta: float) -> void:
	text = str(get_tree().get_nodes_in_group("bullet").size())
