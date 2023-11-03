extends Node2D

const GEMS := [
	preload("gems/gems_blue_1.png"),
	preload("gems/gems_blue_2.png"),
	preload("gems/gems_blue_3.png"),
	preload("gems/gems_blue_4.png"),
	preload("gems/gems_blue_5.png"),
	preload("gems/gems_mixed_2.png"),
]

# The size of one cell in pixels.
const CELL_SIZE := Vector2(50.0, 50.0)
# Maximum random offset applied to a grass strand in pixels.
const MAX_OFFSET := Vector2(10.0, 10.0)
# Maximum angle applied to a grass strand clockwise or counterclockwise.
const MAX_ANGLE := PI / 4.0

var gems_count := GEMS.size()


func _ready() -> void:
	generate_gems(10, 10)


func generate_gems(columns: int, rows: int) -> void:
	# Add two nested loops to generate cell coordinates.
	# Generate the columns with the first loop and the rows with the second.

	# You'll need to indent the lines below to be inside the inner loop block.
	# You can select the lines with the mouse and press Tab to do so.
	# Update the cell value to represent the cell coordinates on each loop iteration.
	var cell := Vector2(0, 0)
	generate_one_gem(cell)


# Generates one gem, offsets and rotates it randomly, and places it at the desired `cell` coordinates.
func generate_one_gem(cell: Vector2) -> void:
	var gem := Sprite.new()
	gem.texture = GEMS[randi() % gems_count]
	add_child(gem)
	gem.position = cell * CELL_SIZE + CELL_SIZE / 2.0 + Vector2(randf(), randf()) * MAX_OFFSET - MAX_OFFSET / 2.0
	gem.rotation = randf() * MAX_ANGLE * 2.0 - MAX_ANGLE
