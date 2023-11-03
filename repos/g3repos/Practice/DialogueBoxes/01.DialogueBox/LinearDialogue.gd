extends PanelContainer

const dialogue := [
	{"name": "Dani", "texture": preload("../common/portraits/dani_sad.png"), "text": "I'll never make it!"},
	{"name": "Sophia", "texture": preload("../common/portraits/sophia_surprised.png"), "text": "What's going on, Dani?"},
	{"name": "Dani", "texture": preload("../common/portraits/dani_sad.png"), "text": "I've been stuck with this code for days! I'll never manage..."},
	{"name": "Sophia", "texture": preload("../common/portraits/sophia_surprised.png"), "text": "Code? What are you coding, exactly?"},
	{"name": "Dani", "texture": preload("../common/portraits/dani_sad.png"), "text": "A dialogue system. It's so frickin' hard!"},
	{"name": "Sophia", "texture": preload("../common/portraits/sophia_happy.png"), "text": "Hard? Really? It's just like that slideshow you made the other day."},
]

var line_index := 0
var last_line_index := dialogue.size() - 1

onready var texture_rect := $MarginContainer/HBoxContainer/PanelContainer/TextureRect
onready var name_label := $MarginContainer/HBoxContainer/VBoxContainer/NameLabel
onready var text_label := $MarginContainer/HBoxContainer/VBoxContainer/TextLabel


func _ready() -> void:
	show_line(0)


func show_line(new_line_index: int) -> void:
	line_index = new_line_index

	var line_data: Dictionary = dialogue[line_index]
	text_label.text = line_data["text"]
	# Display the texture in the texture_rect and the name in the name_label.


func advance() -> void:
	if line_index < last_line_index:
		show_line(line_index + 1)
