tool
extends RoomEntrance

enum Direction {BLOCK_FROM_LEFT, BLOCK_FROM_RIGHT}

export (Direction) var direction := Direction.BLOCK_FROM_LEFT setget set_direction


func _ready() -> void:
	set_direction(direction)

func set_direction(new_direction: int) -> void:
	direction = new_direction
	if not _collider:
		yield(self, "ready")
	_collider.rotation = direction * PI - PI / 2.0
	print(_collider.rotation)
