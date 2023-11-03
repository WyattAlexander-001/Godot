extends Node2D

onready var sprite := $Godot/Sprite
onready var slider := $CanvasLayer/VBoxContainer/HSlider
onready var label := $CanvasLayer/VBoxContainer/Label


func _ready() -> void:
	slider.connect("value_changed", self, "_on_HSlider_value_changed")
	slider.value = sprite.frame
	label.text = str(sprite.frame)


func _on_HSlider_value_changed(value: float) -> void:
	label.text = str(value)
	# Change the sprite's frame based on the slider's value.
