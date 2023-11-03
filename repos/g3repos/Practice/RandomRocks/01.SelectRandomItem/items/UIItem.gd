extends Panel

onready var texture_rect := $TextureRect
onready var label := $Label

func setup(data: Dictionary) -> void:
	texture_rect.texture = data["texture"]
	label.text = data["name"]
