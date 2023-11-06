extends MarginContainer

onready var _quit_button: Button = $VBoxContainer/Quit
onready var _quit_dialog: ConfirmationDialog = $QuitDialog


func _ready() -> void:
	_quit_button.connect("pressed", _quit_dialog, "popup")
