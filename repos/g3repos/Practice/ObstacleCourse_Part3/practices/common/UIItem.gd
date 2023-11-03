extends Control

signal tooltip_requested
signal drag_started


var item = null setget set_item

onready var texture_rect := $TextureRect
onready var amount_label := $AmountLabel
onready var name_label := $NameLabel
onready var tooltip_timer := $TooltipTimer
onready var drop_timer := $DropTimer


func _ready() -> void:
	tooltip_timer.connect("timeout", self, "_request_tooltip")
	connect("mouse_entered", tooltip_timer, "start")
	connect("mouse_exited", tooltip_timer, "stop")


# new item data is an Item instance
func set_item(new_item_data) -> void:
	item = new_item_data
	drop_timer.start()
	for control in [texture_rect, name_label, amount_label]:
		control.visible = item != null

	if item:
		texture_rect.texture = item.icon_texture
		name_label.text = item.display_name
		amount_label.text = str(item.amount).pad_zeros(2)


func _gui_input(event: InputEvent) -> void:
	if not item or not drop_timer.is_stopped():
		return

	if event.is_action_pressed("click"):
		emit_signal("drag_started")
		tooltip_timer.stop()
		set_item(null)


func _request_tooltip() -> void:
	if item:
		emit_signal("tooltip_requested")
