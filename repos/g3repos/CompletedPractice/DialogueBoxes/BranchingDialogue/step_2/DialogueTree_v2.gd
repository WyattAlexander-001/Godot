extends PanelContainer

var dialogue = {
	0: {
		"text": "Hey, [i]wake up![/i] It's time to make video games.",
		"character": "Sophia",
		"expression": "neutral",
		"buttons":
		{
			"Let me sleep a little longer": 2,
			"Let's do it!": 1,
		}
	},
	1: {
		"text": "Great! Your first task will be to write a [b]dialogue tree[/b].",
		"character": "Sophia",
		"expression": "neutral",
		"buttons":
		{
			"I'm not sure if I'm ready, but I will do my best": 3,
			"No, let me go back to sleep": 2,
		}
	},
	2: {
		"text": "Oh, come on! It'll be fun.",
		"character": "Sophia",
		"expression": "sad",
		"buttons":
		{
			"No, really, let me go back to sleep": 0,
			"Alright, I'll try": 3,
		}
	},
	3: {
		"text": "That's the spirit! You can do it!\n[wave][b]YOU WIN[/b][/wave]",
		"character": "Sophia",
		"expression": "happy",
		"buttons": {}
	}
}


onready var texture_rect := $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
onready var rich_text_label := $MarginContainer/VBoxContainer/HBoxContainer/RichTextLabel
onready var buttons_column := $MarginContainer/VBoxContainer/ButtonsColumn

onready var tween := $Tween
onready var audio_player := $AudioStreamPlayer


func _ready() -> void:
	show_line(0)
	# We call the AudioStreamPlayer's stop() function when the text animation
	# completes.
	tween.connect("tween_all_completed", audio_player, "stop")


func show_line(id: int) -> void:
	var line_data: Dictionary = dialogue[id]
	set_text(line_data.text)
	set_expression(line_data.expression)

	for button in buttons_column.get_children():
		button.queue_free()
	if line_data.buttons:
		create_buttons(line_data.buttons)
	else:
		add_quit_button()


func set_text(new_text: String) -> void:
	rich_text_label.bbcode_text = new_text

	# We calculate the animation's duration to display 60 characters per second.
	var duration: float = rich_text_label.text.length() / 60.0
	tween.interpolate_property(rich_text_label, "percent_visible", 0.0, 1.0, duration)
	tween.start()

	# We randomize the audio playback's start time to make it sound different
	# every time.
	var sound_start_position: float = randf() * audio_player.stream.get_length()
	audio_player.play(sound_start_position)


func set_expression(expression: String) -> void:
	match expression:
		"sad":
			texture_rect.texture = preload("portraits/sophia_sad.png")
		"happy":
			texture_rect.texture = preload("portraits/sophia_happy.png")
		_:
			texture_rect.texture = preload("portraits/sophia_neutral.png")


func add_quit_button() -> void:
	var button := Button.new()
	button.text = "Quit"
	button.connect("pressed", get_tree(), "quit")
	buttons_column.add_child(button)


func create_buttons(buttons_data: Dictionary) -> void:
	for text in buttons_data:
		var button := Button.new()
		var target_line_id: int = buttons_data[text]
		button.text = text
		button.connect("pressed", self, "show_line", [target_line_id])
		buttons_column.add_child(button)
