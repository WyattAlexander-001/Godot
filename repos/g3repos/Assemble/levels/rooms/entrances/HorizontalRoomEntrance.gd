tool
extends RoomEntrance

enum Direction {BLOCK_FROM_TOP, BLOCK_FROM_BOTTOM}

export (Direction) var direction := Direction.BLOCK_FROM_BOTTOM setget set_direction


func set_direction(new_direction: int) -> void:
	direction = new_direction
	if not _collider:
		yield(self, "ready")
	_collider.rotation = direction * PI
