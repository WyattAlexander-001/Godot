extends Control

func game_over() -> void:
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_try_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_to_desktop_pressed() -> void:
	get_tree().quit()

