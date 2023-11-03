extends HBoxContainer

onready var texture_rect := $PanelContainer/TextureRect
onready var label := $Label


func set_text(new_text) -> void:
	label.text = new_text


func set_texture(texture: Texture) -> void:
	texture_rect.texture = texture
