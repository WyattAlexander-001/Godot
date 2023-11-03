extends Control

var slideshow_data := [
	{"text": "In this series, you'll code a slideshow."},
	{"text": "You can use the techniques you'll see here for simple cut-scenes, linear conversations, and more."},
	{"text": "What you'll see here isn't limited to conversations. You'll learn the basics behind any sequence of events."},
	{"text": 'We will build upon this series to later create a branching dialogue system, a sort of "choose your own adventure" toy.'},
]

var current_slide_index := 0
var last_slide_index := slideshow_data.size() - 1

onready var label := $VBoxContainer/Label
onready var button := $VBoxContainer/Button


func _ready() -> void:
	show_slide(0)
	button.connect("pressed", self, "advance")


func show_slide(new_slide_index: int) -> void:
	current_slide_index = new_slide_index

	var current_slide_data: Dictionary = slideshow_data[current_slide_index]
	set_text(current_slide_data["text"])
	if current_slide_index == last_slide_index:
		button.text = "Quit"


# In the next lesson, we'll animate the text and need multiple lines of code to
# do so. That's why we define a function just to change the displayed text.
func set_text(new_text: String) -> void:
	label.text = new_text


func advance() -> void:
	if current_slide_index == last_slide_index:
		get_tree().quit()
	else:
		show_slide(current_slide_index + 1)
