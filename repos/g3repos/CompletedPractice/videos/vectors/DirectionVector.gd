extends Vector2D

const COLOR_CIRCLE := Color(0.14902, 0.776471, 0.968627)

export var drawing_length := 200.0
export var circle_offset := 25.0

onready var label := $Label

func _ready() -> void:
	label.rect_position.x = -label.rect_size.x / 2.0
	label.rect_position.y = -drawing_length - circle_offset - label.rect_size.y - 20


func _draw() -> void:
	._draw()
	draw_circle_outline(
		Vector2.ZERO, drawing_length + circle_offset, COLOR_CIRCLE, DEFAULT_LINE_THICKNESS
	)


func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if not direction.is_equal_approx(vector):
		set_vector(direction * drawing_length)


func set_vector(value: Vector2) -> void:
	.set_vector(value)
	if not label:
		yield(label, "ready")
	label.text = "Direction: Vector2" + str(vector.normalized().snapped(Vector2(0.1, 0.1)))
