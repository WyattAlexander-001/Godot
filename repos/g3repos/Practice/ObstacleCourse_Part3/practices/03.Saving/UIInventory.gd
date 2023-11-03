extends Control

const Inventory := preload("Inventory.gd")
const Item := preload("Item.gd")
const UIItem := preload("../common/UIItem.gd")
const UIItemScene := preload("../common/UIItem.tscn")

export(Resource) var inventory setget set_inventory
export var max_items := 10

var _dragged_item: Item = null

onready var item_grid := $ItemGrid
onready var ui_tooltip := $UITooltip
onready var drag_preview := $UIDraggedItemPreview


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
	
	for idx in max_items:
		var item = inventory.items[idx] if inventory and idx < inventory.items.size() else null
		var ui_item := UIItemScene.instance()
		item_grid.add_child(ui_item)
		ui_item.item = item
		ui_item.connect("tooltip_requested", self, "_on_tooltip_requested", [ui_item])
		ui_item.connect("drag_started", self, "_on_drag_started", [ui_item])


func _on_tooltip_requested(ui_item: UIItem) -> void:
	ui_tooltip.display(ui_item.item.description, get_global_mouse_position())


func _on_drag_started(ui_item: UIItem) -> void:
	_set_dragged_item(ui_item.item)
	set_process_input(true)


func _drop_item() -> void:
	for ui_item in item_grid.get_children():
		if ui_item.get_global_rect().has_point(get_global_mouse_position()):
			var item_to_swap: Item = ui_item.item
			ui_item.item = _dragged_item
			_set_dragged_item(item_to_swap)
			break
	set_process_input(_dragged_item != null)


func _set_dragged_item(item: Item) -> void:
	_dragged_item = item
	if _dragged_item:
		drag_preview.display(item)
	else:
		drag_preview.hide()


func set_inventory(new_inventory: Resource) -> void:
	assert(new_inventory is Inventory, "inventory must be a resource of Inventory type")
	inventory = new_inventory
