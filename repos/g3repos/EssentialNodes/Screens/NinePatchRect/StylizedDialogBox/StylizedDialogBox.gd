extends Control

## Display speed of the text in characters per second.
const TEXT_DISPLAY_SPEED := 60.0

const LINES := [
	"What does all this do? I don't trust it,\ndon't touch anything.",
	"I found it! There's something under here!",
	"Ugh...\nso bored...help me...",
	"Thanks for the help!",
	"You go on ahead, I'll hang back in case the others show up.",
	"Wait...\nAre you really sure about that?",
]

onready var _end_button: TextureButton = find_node("TextureButton")
onready var _label: RichTextLabel = find_node("RichTextLabel")
onready var _tween: Tween = $Tween

func _ready() -> void:
	_end_button.connect("pressed", self, "_advance_dialog")
	_tween.connect("tween_completed", self, "_on_Tween_tween_completed")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_advance_dialog()


func _advance_dialog() -> void:
	# Finish the dialog if it's not done yet.
	if _tween.is_active():
		_tween.remove_all()
		_label.percent_visible = 1.0
		_end_button.visible = true
		return

	# Otherwise, start the next piece of dialog.
	_end_button.visible = false
	_label.bbcode_text = LINES.front()
	# We cycle lines of text in the array by pushing and popping its contents.
	LINES.push_back(LINES.pop_front())
	# Interpolation speed is based on text length.
	_tween.interpolate_property(
		_label, "percent_visible", 0.0, 1.0, len(_label.text) / TEXT_DISPLAY_SPEED
	)
	_tween.start()


func _on_Tween_tween_completed(_object: Object, key: NodePath) -> void:
	if key == ":percent_visible":
		_end_button.visible = true
