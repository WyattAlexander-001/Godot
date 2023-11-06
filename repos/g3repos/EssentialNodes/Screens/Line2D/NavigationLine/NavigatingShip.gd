extends Path2D

const SPEED := 666.0
const MIN_LENGTH := 10.0

onready var _halo := $HaloCircle
onready var _tween := $Tween
onready var _path_follow := $PathFollow


func get_global_position() -> Vector2:
	return _path_follow.global_position


func get_curve_path() -> PoolVector2Array:
	return curve.get_baked_points()


func set_path(path: PoolVector2Array) -> void:
	curve.clear_points()
	for point in path:
		curve.add_point(point)


func move_to(target_position: Vector2) -> void:
	_tween.remove_all()

	_halo.global_position = target_position
	_tween.interpolate_property(_halo, "size", 0, 100, 1.0)
	_tween.interpolate_property(_halo, "modulate", Color.white, Color.transparent, 1.0)
	_tween.interpolate_property(
		_path_follow, "unit_offset", 0.0, 1.0, curve.get_baked_length() / SPEED
	)
	_tween.start()
