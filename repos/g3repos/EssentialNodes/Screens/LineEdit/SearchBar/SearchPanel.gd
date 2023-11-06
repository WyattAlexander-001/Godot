extends NinePatchRect

export (Array, Texture) var icon_list
export (PackedScene) var icon_scene

onready var _container: GridContainer = $VBoxContainer/ScrollContainer/GridContainer
onready var _line_edit: LineEdit = $VBoxContainer/LineEdit
onready var _avatar: TextureRect = $Avatar/TextureRect


func _ready() -> void:
	for icon_texture in icon_list:
		var icon = icon_scene.instance()
		icon.setup(icon_texture)
		icon.connect("selected", self, "icon_selected")
		_container.add_child(icon)


func icon_selected(texture_in: Texture):
	update_preview(_line_edit.text)
	_avatar.texture = texture_in


func update_preview(text_in: String) -> void:
	for child in _container.get_children():
		var is_search_similar := text_in.similarity(child._label.text.to_lower()) > 0.33
		var is_search_in_text := text_in.is_subsequence_of(child._label.text.to_lower())
		var is_icon_pressed: bool = child.get_pressed()

		child.visible = is_search_similar or is_search_in_text or is_icon_pressed
