extends Node2D

## Display speed of the text in characters per second.
const TEXT_DISPLAY_SPEED := 50.0
const LINES = [
	"What does all this do? I don't trust it,\ndon't touch anything.",
	"I found it! There's something under here!",
	"Ugh...\nso bored...help me...",
	"Thanks for the help!",
	"You go on ahead, I'll hang back in case the others show up.",
	"Wait...\nAre you really sure about that?",
]

onready var _label: Label = $CenterContainer/PanelContainer/Label
onready var _tween: Tween = $Tween


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_play_dialog()




func _play_dialog() -> void:
	_label.text = LINES.front()
	# We cycle lines of text in the array.
	LINES.push_back(LINES.pop_front())
	_tween.interpolate_property(
		_label, "percent_visible", 0.0, 1.0, len(_label.text) / TEXT_DISPLAY_SPEED
	)
	_tween.start()
