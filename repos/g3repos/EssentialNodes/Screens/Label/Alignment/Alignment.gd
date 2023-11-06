extends Control

onready var _label := $NinePatchRect/Label


func _on_VOptionButton_item_selected(index: int) -> void:
	_label.valign = index


func _on_HOptionButton_item_selected(index: int) -> void:
	_label.align = index
