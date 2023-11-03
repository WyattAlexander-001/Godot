extends ColorRect

onready var _quit_button := $Panel/Margin/Column/Row/QuitButton
onready var _stay_button := $Panel/Margin/Column/Row/StayButton


func _ready() -> void:
	_stay_button.connect("pressed", self, "hide")
	_quit_button.connect("pressed", get_tree(), "quit")
