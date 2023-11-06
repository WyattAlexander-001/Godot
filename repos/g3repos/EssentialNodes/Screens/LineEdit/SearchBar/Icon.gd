extends Control

onready var _texture_rect: TextureRect = $TextureRect
onready var _button: Button = $Button
onready var _label: Label = $Label

signal selected(texture_out)


func setup(texture_in: Texture) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	_texture_rect.texture = texture_in
	_label.text = texture_in.resource_path.get_file().get_basename()
	_button.connect("pressed", self, "pressed")


func get_pressed() -> bool:
	return _button.pressed


func pressed() -> void:
	emit_signal("selected", _texture_rect.texture)
