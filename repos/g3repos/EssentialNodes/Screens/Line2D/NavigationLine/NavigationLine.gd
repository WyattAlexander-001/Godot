extends Node2D

onready var navigator: Navigation2D = $Navigation2D
onready var _line2d: Line2D = $Line2D
onready var _ship := $Ship


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("move_to_target"):
		var path: PoolVector2Array = navigator.get_simple_path(
			_ship.get_global_position() - global_position,
			get_global_mouse_position() - global_position
		)
		_ship.set_path(path)
		_line2d.points = _ship.get_curve_path()
		_ship.move_to(get_global_mouse_position())
