extends Button


func _on_Reset_pressed() -> void:
	get_tree().reload_current_scene()
