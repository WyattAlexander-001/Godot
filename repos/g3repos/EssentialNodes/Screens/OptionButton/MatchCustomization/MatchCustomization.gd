extends Control

onready var _option_list: MarginContainer = $MainRect/VBoxContainer/HBoxContainer/OptionsList
onready var _label: Label = $LoadingRect/MarginContainer/VBoxContainer/Label
onready var _play_button: Button = $MainRect/VBoxContainer/Button
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_play_button.connect("pressed", _animation_player, "play", ["loading_transition"])

func show_mode() -> void:
	_label.text = _option_list.mode_button.get_item_text(_option_list.mode_button.get_selected_id())


func show_map() -> void:
	_label.text = _option_list.map_button.get_item_text(_option_list.map_button.get_selected_id())


func show_size() -> void:
	_label.text = _option_list.map_size_button.get_item_text(_option_list.map_size_button.get_selected_id())
