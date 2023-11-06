tool
extends PanelContainer

export var title := "player"

onready var _label: Label = $MarginContainer/HBoxContainer/Label


func _ready() -> void:
	_label.text = title
