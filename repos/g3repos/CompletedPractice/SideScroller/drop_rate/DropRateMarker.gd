tool
extends Label

func _physics_process(_delta: float) -> void:
	text = str(rect_position.y)
