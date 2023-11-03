extends Control

onready var demo_list := $Margin/HBoxContainer/VBoxContainer/PanelContainer/DemoList
onready var _search_bar := $Margin/HBoxContainer/VBoxContainer/SearchBar as LineEdit
onready var _background := $BackgroundLayer/ScrollingSky


func _ready() -> void:
	_search_bar.connect("text_changed", demo_list, "update_display")
	if get_parent():
		get_parent().connect("fullscreen_toggled", _background, "update_size")


func setup(scenes_metadata: Array) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	demo_list.create_demo_buttons(scenes_metadata, false)


func hide() -> void:
	.hide()
	_background.hide()


func show() -> void:
	.show()
	_background.show()
