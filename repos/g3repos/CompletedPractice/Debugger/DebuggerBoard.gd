tool
class_name DebuggerBoard
extends Node2D

export var board_width := 3 setget set_grid_width
export var board_height := 3 setget set_grid_height
export var cell_size := Vector2(64, 64)
export var line_width := 4

var grid_size := Vector2(board_width, board_height)
var grid_size_px := cell_size * grid_size


func _ready() -> void:
	update()


# Draws a grid to represent the game board.
func _draw() -> void:
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var cell_position := Vector2(x, y) * cell_size - cell_size / 2.0
			draw_rect(Rect2(cell_position, cell_size), Color.white, false, line_width)


func set_grid_width(width: int) -> void:
	board_width = width
	grid_size.x = width
	grid_size_px = grid_size * cell_size
	update()


func set_grid_height(height: int) -> void:
	board_height = height
	grid_size.y = height
	grid_size_px = grid_size * cell_size
	update()
