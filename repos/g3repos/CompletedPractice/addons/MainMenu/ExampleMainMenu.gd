tool
extends Control

export var background_scene: PackedScene setget set_background_scene
export var title_graphic: StreamTexture setget set_title_graphic

onready var demo_list: UIDemoList = $Margin/CenterContainer/VBoxContainer/PanelContainer/DemoList

onready var _background_layer := $BackgroundLayer as CanvasLayer
onready var _title_rect := $Margin/CenterContainer/VBoxContainer/TitleContainer/TextureRect as TextureRect


func set_background_scene(new_background: PackedScene) -> void:
	background_scene = new_background
	if not _background_layer:
		yield(self, "ready")
	for child in _background_layer.get_children():
		child.queue_free()
	_background_layer.add_child(background_scene.instance())


func set_title_graphic(new_texture: StreamTexture) -> void:
	title_graphic = new_texture
	if not _title_rect:
		yield(self, "ready")
	_title_rect.texture = title_graphic
	_title_rect.rect_min_size.y = title_graphic.get_height()
