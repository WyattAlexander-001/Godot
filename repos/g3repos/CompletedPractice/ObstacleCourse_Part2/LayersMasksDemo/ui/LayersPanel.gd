extends NinePatchRect

export var target_node_path: NodePath
export(Texture) var icon_texture

var texture_inactive := preload("res://ObstacleCourse_Part2/LayersMasksDemo/assets/9patch_mainmenu.png")
var texture_active := preload("res://ObstacleCourse_Part2/LayersMasksDemo/assets/9patch_mainmenu_active.png")
var active := false

onready var target_node := get_node(target_node_path)
onready var target_parent := target_node.get_parent()
onready var layer_buttons_container := $MarginContainer/LayersMasks/LayerButtons
onready var mask_buttons_container := $MarginContainer/LayersMasks/MaskButtons
onready var object_label := $MarginContainer/LayersMasks/ObjectLabel/Label
onready var icon := $MarginContainer/LayersMasks/ObjectLabel/CenterContainer/TextureRect


func _ready() -> void:
	target_node.connect("tree_exiting", self, "queue_free")
	
	icon.texture = icon_texture
	object_label.text = target_parent.name
	for i in layer_buttons_container.get_child_count():
		layer_buttons_container.get_child(i).pressed = target_parent.get_collision_layer_bit(i)

	for i in mask_buttons_container.get_child_count():
		mask_buttons_container.get_child(i).pressed = target_parent.get_collision_mask_bit(i)

	for i in layer_buttons_container.get_child_count():
		layer_buttons_container.get_child(i).connect("pressed", self, "toggle_collision_layer", [i])

	for i in mask_buttons_container.get_child_count():
		mask_buttons_container.get_child(i).connect("pressed", self, "toggle_collision_mask", [i])


func toggle_collision_layer(bit) -> void:
	var prev_value = target_parent.get_collision_layer_bit(bit)
	target_parent.set_collision_layer_bit(bit, !prev_value)


func toggle_collision_mask(bit) -> void:
	var prev_value = target_parent.get_collision_mask_bit(bit)
	target_parent.set_collision_mask_bit(bit, !prev_value)


func _on_LayersPanel_mouse_entered() -> void:
	active = true
	texture = texture_active
	target_node.show()


func _on_LayersPanel_mouse_exited() -> void:
	active = false
	texture = texture_inactive
	target_node.hide()
