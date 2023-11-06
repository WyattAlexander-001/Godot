extends Node2D

export var card_art: Texture
export var rules_text: String
export var name_text: String

onready var _art: TextureRect = $CardBorder/VBoxContainer/CardArt
onready var _name_label: Label = $CardBorder/VBoxContainer/TextPanel/VBoxContainer/Label
onready var _rules_text: RichTextLabel = $CardBorder/VBoxContainer/TextPanel/VBoxContainer/RichTextLabel


func _ready() -> void:
	_art.texture = card_art
	_name_label.text = name_text
	_rules_text.bbcode_text = rules_text
