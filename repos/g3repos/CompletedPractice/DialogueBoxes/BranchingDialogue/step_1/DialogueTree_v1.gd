extends PanelContainer

var dialogue = {
	0: {
		"text": "Hey, [i]wake up![/i] It's time to make video games.",
		"expression": "neutral",
		"buttons":
		{
			"Let me sleep a little longer": 2,
			"Let's do it!": 1,
		}
	},
	1: {
		"text": "Great! Your first task will be to write a [b]dialogue tree[/b].",
		"expression": "neutral",
		"buttons":
		{
			"I'm not sure if i'm ready, but i will do my best": 3,
			"No, let me go back to sleep": 2,
		}
	},
	2: {
		"text": "Oh, come on! It'll be fun.",
		"expression": "sad",
		"buttons":
		{
			"No, really, let me go back to sleep": 0,
			"Alright, I'll try": 3,
		}
	},
	3: {
		"text": "That's the spirit! You can do it!\n[wave][b]YOU WIN[/b][/wave]",
		"expression": "happy",
		"buttons": {}
	}
}

onready var texture_rect := $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
onready var rich_text_label := $MarginContainer/VBoxContainer/HBoxContainer/RichTextLabel
onready var buttons_column := $MarginContainer/VBoxContainer/ButtonsColumn


func _ready() -> void:
	show_line(0)


func show_line(id: int) -> void:
	# We extract the line's data from the `dialogue` variable.
	var line_data: Dictionary = dialogue[id]
	# We then pass the text and expression values of the line's data to
	# functions that update the displayed text and character portrait.
	set_text(line_data.text)
	set_expression(line_data.expression)

	for button in buttons_column.get_children():
		# Use this function to safely destroy a node when you don't need it
		# anymore.
		button.queue_free()

	if line_data.buttons:
		create_buttons(line_data.buttons)
	# If the line has no buttons, we reached the dialogue's end, so we create a
	# single quit button.
	else:
		add_quit_button()


func set_text(new_text: String) -> void:
	rich_text_label.bbcode_text = new_text


func set_expression(expression: String) -> void:
	if expression == "sad":
		texture_rect.texture = preload("portraits/sophia_sad.png")
	# Elif is the contraction of "else if." This block will run if the previous
	# condition didn't pass.
	elif expression == "happy":
		texture_rect.texture = preload("portraits/sophia_happy.png")
	# Any `expression` that we don't list above will display the neutral
	# character portrait.
	else:
		texture_rect.texture = preload("portraits/sophia_neutral.png")


func add_quit_button() -> void:
	var button := Button.new()
	button.text = "Quit"
	buttons_column.add_child(button)
	# We can directly connect a signal to a function or another object. Clicking
	# the button will call the scene tree's quit() function.
	button.connect("pressed", get_tree(), "quit")


func create_buttons(buttons_data: Dictionary) -> void:
	for text in buttons_data:
		var button := Button.new()
		button.text = text
		buttons_column.add_child(button)
		var target_line_id: int = buttons_data[text]
		# The last argument means that pressing the button will call the
		# show_line() function with the value of `target_line_id`.
		#
		# We must store this value in an array as this is what the connect()
		# function expects.
		button.connect("pressed", self, "show_line", [target_line_id])
