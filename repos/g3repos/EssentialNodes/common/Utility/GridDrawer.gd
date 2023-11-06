extends Node2D

export var cell_size: float = 64
export var cell_count: int = 96
export var grid_origin := Vector2()

## Draws the background grid.
func _draw() -> void:
	if cell_size == 0:
		return

	var position_origin := grid_origin * cell_size

	var half_cell_count := int(cell_count / 2.0)
	var half_cell_size := cell_size / 2.0

	for x in range(-half_cell_count, half_cell_count):
		for y in range(-half_cell_count, half_cell_count):
			var cell_rect := Rect2(
				Vector2(
					position_origin.x + x * cell_size - half_cell_size,
					position_origin.y + y * cell_size - half_cell_size
				),
				Vector2(cell_size, cell_size)
			)

			draw_rect(cell_rect, Color.skyblue, false)


func setup(size: float, count: int) -> void:
	cell_size = size
	cell_count = count
	update()


func move_grid_to(origin: Vector2) -> void:
	grid_origin = origin
	update()
