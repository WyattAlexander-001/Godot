extends Area2D

signal requested_move(vector)

onready var vector_visualizer := $Vector2D

var is_pressed := false
var vector := Vector2()


func _input(event: InputEvent) -> void:
	if not is_pressed:
		return
	if event is InputEventMouseButton:
		is_pressed = false
		emit_signal("requested_move", vector * 100)
		vector = Vector2.ZERO
	elif event is InputEventMouseMotion:
		vector = (get_global_mouse_position() - global_position).clamped(300)


func _process(_delta: float) -> void:
	vector_visualizer.position = global_position
	vector_visualizer.vector = vector


func _ready() -> void:
	connect("input_event", self, "_on_input_event")
	vector_visualizer.set_as_toplevel(true)


func _on_input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch):
		if event.pressed:
			is_pressed = true
		else:
			is_pressed = false
