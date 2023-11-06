# Lets you drag, drop, and swap textures between TextureRects. Uses drag fowarding.
extends Control

# We store a reference to the previously dragged item when swapping it with
# another.
var _last_dragged_item: TextureRect

onready var _grid: GridContainer = $RecoveryPanel/GridContainer
onready var _recovery_panel: PanelContainer = $RecoveryPanel


func _ready() -> void:
	# First, we find all the draggable items in the inventory.
	var texture_rects := []
	for item_slot in _grid.get_children():
		for item in item_slot.get_children():
			if item is TextureRect:
				texture_rects.append(item)

	# We then redirect calls from the children's drag and drop functions to this
	# script.
	for item in texture_rects:
		item.set_drag_forwarding(self)

	# We use a panel in the background to detect when the player drags an item
	# away from the inventory slots.
	_recovery_panel.connect(
		"data_recovered", self, "_on_RecoveryPanel_data_recovered"
	)




func get_drag_data_fw(_position: Vector2, source_control: Control) -> Texture:
	_last_dragged_item = source_control

	var _texture: Texture = source_control.texture
	source_control.texture = null
	set_drag_preview(make_preview(_texture))
	# We return the texture so it'll become the `dragged_texture` in
	# can_drop_data_fw() and drop_data_fw().
	return _texture


func can_drop_data_fw(
	_position: Vector2, dragged_texture: Texture, _target_control: Control
) -> bool:
	# We check that dragged data exists to prevent us from overwriting a slot with null.
	return dragged_texture != null


func drop_data_fw(_position: Vector2, dragged_texture: Texture, new_slot: Control) -> void:
	var new_texture: Texture = new_slot.texture
	# If the target slot is empty, we assign the dragged texture to it.
	if new_texture == null:
		new_slot.texture = dragged_texture
	# If the target slot contains something, 
	else:
		var data_to_replace: Texture = new_slot.texture
		_last_dragged_item.texture = data_to_replace
		new_slot.texture = dragged_texture


func _on_RecoveryPanel_data_recovered(data: Texture) -> void:
	# Any data dropped on the panel behind the grid is returned here, and set as
	# the last dragged item's texture.
	_last_dragged_item.texture = data


# Creates a smaller preview image to display when calling set_drag_preview()
func make_preview(texture: Texture) -> TextureRect:
	var preview := TextureRect.new()
	preview.rect_size = Vector2(64, 64)
	preview.texture = texture
	preview.expand = true
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	return preview
