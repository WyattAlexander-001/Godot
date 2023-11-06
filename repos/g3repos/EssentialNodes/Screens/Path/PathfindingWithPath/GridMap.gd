extends GridMap


func get_used_aabb() -> AABB:
	var cells := get_used_cells()
	cells.sort()

	var first: Vector3 = cells.front()
	var last: Vector3 = cells.back()
	return AABB(first, last - first + Vector3.ONE)
