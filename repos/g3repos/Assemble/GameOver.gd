extends Control


func _on_RestartButton_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
