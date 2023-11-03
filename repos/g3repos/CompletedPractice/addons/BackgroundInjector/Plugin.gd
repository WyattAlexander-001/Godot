# Injects a background into any scene except for the game's entry point.
tool
extends EditorPlugin

func _enter_tree() -> void:
	var this_dir: String = get_script().resource_path.rsplit("/", true, 1)[0]
	var path := this_dir.plus_file("BackgroundInjector.gd")
	add_autoload_singleton("BackgroundInjector", path)
