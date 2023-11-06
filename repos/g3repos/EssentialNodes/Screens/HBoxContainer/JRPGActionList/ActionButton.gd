## Individual button representing one combat action.
extends TextureButton

# Image to appear on the button.
export (Texture) var icon: Texture
# Text to appear on the button.
export (String) var text := ""

onready var _icon_node: TextureRect = $HBoxContainer/Icon
onready var _label_node: Label = $HBoxContainer/Label


func _ready() -> void:
	_icon_node.texture = icon
	_label_node.text = text


## Prevents the player from navigating to other buttons with the keyboard after pressing this one.
func _pressed() -> void:
	release_focus()
