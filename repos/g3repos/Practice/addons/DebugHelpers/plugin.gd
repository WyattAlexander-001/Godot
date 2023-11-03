tool
extends EditorPlugin

const autoload_name := "HelpersInjector"
const autoload_file := autoload_name + ".gd"

func _enter_tree() -> void:
	var autoload_path := preload(autoload_file).resource_path
	add_autoload_singleton(autoload_name, autoload_path)


func _exit_tree() -> void:
	remove_autoload_singleton(autoload_name)
