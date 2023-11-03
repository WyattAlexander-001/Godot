extends Panel

const UIItem := preload("../common/UIItem.gd")
const UIItemScene := preload("../common/UIItem.tscn")

export(Array, Resource) var items := [] setget set_items

onready var item_grid := $ItemGrid
onready var ui_tooltip := $UITooltip
onready var drag_preview := $UIDraggedItemPreview


func _ready() -> void:
	update_items_display()
	set_process_input(false)


func update_items_display() -> void:
	for node in item_grid.get_children():
		node.queue_free()

	for item in items:
		var ui_item := UIItemScene.instance()
		item_grid.add_child(ui_item)
		ui_item.item = item
		ui_item.connect("tooltip_requested", self, "_on_tooltip_requested", [ui_item])


func _on_tooltip_requested(ui_item: UIItem) -> void:
	ui_tooltip.display(ui_item.item.description, get_global_mouse_position())


func set_items(new_items: Array) -> void:
	for index in new_items.size():
		var item = new_items[index]
		assert(item == null or item is InventoryItem, "Item %s is not an instance of InventoryItem"%[index])
	items = new_items
