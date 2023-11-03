extends Node

signal fullscreen_toggled

onready var _main_menu := $UIMainMenu
onready var _demo_player := $DemoPlayer
onready var _button_go_back := $CanvasLayer/ButtonGoBack

onready var _tree := get_tree()


func _ready() -> void:
	_main_menu.demo_list.connect("demo_requested", self, "load_and_show_demo")
	_button_go_back.connect("pressed", self, "go_back_to_menu")
	_button_go_back.hide()
	for action in ["toggle_fullscreen", "go_back_to_menu"]:
		if not InputMap.has_action(action):
			printerr("Expected input action %s but it does not exist. Turning off input processing for DemoMenu. Please add this input map action to your project." % action)
			set_process_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		emit_signal("fullscreen_toggled")
		_tree.set_input_as_handled()
	elif event.is_action_pressed("go_back_to_menu") and _demo_player.is_loaded():
		go_back_to_menu()
		_tree.set_input_as_handled()


func go_back_to_menu() -> void:
	_demo_player.unload()
	_button_go_back.hide()
	_main_menu.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func load_and_show_demo() -> void:
	_demo_player.load_demo(_main_menu.demo_list.demo_path)
	_main_menu.hide()
	_button_go_back.show()
