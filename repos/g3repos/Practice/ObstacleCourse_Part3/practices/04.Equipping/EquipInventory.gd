extends Control

const Inventory := preload("Inventory.gd")
const Item := preload("../03.Saving/Item.gd")
const UIItem := preload("../common/UIItem.gd")
const UIItemScene := preload("../common/UIItem.tscn")

export(Resource) var inventory setget set_inventory

var _dragged_item: Item = null
# We store the slot to detect placing items in special slots, e.g. the equipment
# ones.
# It'd also allow us to cancel dragging.
var _dragged_item_source_slot: UIItem = null

onready var item_grid := $HBoxContainer/VBoxContainer/ItemGrid
onready var ui_tooltip := $UITooltip
onready var drag_preview := $UIDraggedItemPreview

onready var left_hand_weapon := $HBoxContainer/VBoxContainer/Equipment/LeftHandSlot
onready var right_hand_weapon := $HBoxContainer/VBoxContainer/Equipment/RightHandSlot

onready var _ui_item_nodes := [left_hand_weapon, right_hand_weapon]


func _ready() -> void:
	update_items_display()
	set_process_input(false)


# Dragging
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		_drop_item()


func update_items_display() -> void:
	for node in item_grid.get_children():
		node.queue_free()
	
	for item in inventory.items:
		var ui_item := UIItemScene.instance()
		item_grid.add_child(ui_item)
		_ui_item_nodes.append(ui_item)
		ui_item.item = item
	
	for ui_item in _ui_item_nodes:
		ui_item.connect("tooltip_requested", self, "_on_tooltip_requested", [ui_item])
		ui_item.connect("drag_started", self, "_on_drag_started", [ui_item])


func set_inventory(new_inventory: Resource) -> void:
	assert(new_inventory != null or new_inventory is Inventory, "inventory must be a resource of Inventory type")
	inventory = new_inventory


func _on_tooltip_requested(ui_item: UIItem) -> void:
	ui_tooltip.display(ui_item.item.description, get_global_mouse_position())


func _on_drag_started(ui_item: UIItem) -> void:
	_set_dragged_item(ui_item.item)
	_dragged_item_source_slot = ui_item
	set_process_input(true)


func _drop_item() -> void:
	for ui_item in _ui_item_nodes:
		if ui_item.get_global_rect().has_point(get_global_mouse_position()):
			var item_to_swap: Item = ui_item.item
			ui_item.item = _dragged_item

			# Handle placing weapons in equipment slots vs regular inventory
			# slots.
			if ui_item == left_hand_weapon:
				inventory.left_hand_weapon = _dragged_item
			elif ui_item == right_hand_weapon:
				inventory.right_hand_weapon = _dragged_item
			else:
				inventory.items[ui_item.get_index()] = _dragged_item

			# Clear source equipment and inventory slots.
			if not item_to_swap:
				if _dragged_item_source_slot == left_hand_weapon:
					inventory.left_hand_weapon = null
				elif _dragged_item_source_slot == right_hand_weapon:
					inventory.right_hand_weapon = null
				else:
					inventory.items[_dragged_item_source_slot.get_index()] = null

			_set_dragged_item(item_to_swap)
			break

	set_process_input(_dragged_item != null)


func _set_dragged_item(item: Item) -> void:
	_dragged_item = item
	if _dragged_item:
		drag_preview.display(item)
	else:
		drag_preview.hide()
		_dragged_item_source_slot = null
