extends PanelContainer

var is_active := false setget set_is_active

onready var _tween := $Tween
onready var _title := $VBoxContainer/Title
onready var _body := $VBoxContainer/Body


func _ready() -> void:
	modulate = Color.transparent


func _process(delta: float) -> void:
	rect_global_position = get_global_mouse_position() - rect_pivot_offset
	rect_global_position.x = clamp(rect_global_position.x, 0, 1920 - rect_size.x)


func set_is_active(value: bool):
	is_active = value
	set_process(is_active)

	if is_active:
		modulate = Color.white
		_tween.stop_all()
	else:
		_tween.interpolate_property(self, "modulate", modulate, Color.transparent, 0.2)
		_tween.start()


func set_text(title: String, body: String):
	_title.text = title.capitalize()
	_body.text = body
