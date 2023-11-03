extends Node2D

onready var sprite := $Godot/Sprite
onready var slider := $CanvasLayer/VBoxContainer/HSlider
onready var label := $CanvasLayer/VBoxContainer/Label
onready var check_button_h := $CanvasLayer/VBoxContainer/CheckButtonFlipH
onready var check_button_v := $CanvasLayer/VBoxContainer/CheckButtonFlipV


func _ready() -> void:
	slider.connect("value_changed", self, "_on_HSlider_value_changed")
	check_button_h.connect("toggled", self, "_on_CheckButtonFlipH_toggled")
	check_button_v.connect("toggled", self, "_on_CheckButtonFlipV_toggled")


func _on_HSlider_value_changed(value: float) -> void:
	label.text = str(value)
	sprite.frame = value


func _on_CheckButtonFlipH_toggled(toggled: bool) -> void:
	# Flip the sprite horizontally based on the toggled value.
	pass


func _on_CheckButtonFlipV_toggled(toggled: bool) -> void:
	# Flip the sprite vertically based on the toggled value.
	pass
