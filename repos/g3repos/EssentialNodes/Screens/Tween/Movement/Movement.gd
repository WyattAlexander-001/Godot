extends Node2D

onready var _halo := $HaloCircle
onready var _ship := $ShipContainer
onready var _tween := $Tween


func move_ship_to_click(target_position: Vector2) -> void:
	# We turn the ship to look towards the target.
	_ship.look_at(target_position)
	_tween.interpolate_property(
		_ship, "global_position", _ship.global_position, target_position, 1.0
	)
	_tween.start()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		move_ship_to_click(get_global_mouse_position())
		animate_halo(get_global_mouse_position())


func animate_halo(target_position: Vector2) -> void:
	_halo.global_position = target_position
	_tween.interpolate_property(_halo, "size", 0, 100, 1.0)
	_tween.interpolate_property(_halo, "modulate", Color.white, Color.transparent, 1.0)
	_tween.start()
