extends Panel


onready var texture_rect := $TextureRect
onready var amount_label := $AmountLabel
onready var name_label := $NameLabel


func _ready() -> void:
	set_as_toplevel(true)
	set_process(false)


func _process(_delta: float) -> void:
	rect_position = get_global_mouse_position()


func display(item) -> void:
	texture_rect.texture = item.icon_texture
	name_label.text = item.display_name
	amount_label.text = str(item.amount).pad_zeros(2)
	rect_position = get_global_mouse_position()
	show()
	set_process(true)


func hide() -> void:
	.hide()
	set_process(false)
