extends Node2D

const ROCKS := [
	preload("../rocks/Rock1.tscn"),
	preload("../rocks/Rock2.tscn"),
	preload("../rocks/Rock3.tscn"),
]

const CELL_SIZE := Vector2(128, 128)


func add_rocks_with_blue_noise(columns: int, rows: int) -> void:
	for column in range(columns):
		for row in range(rows):
			var cell := Vector2(column, row)
			var rock: Sprite = ROCKS[randi() % ROCKS.size()].instance()
			add_child(rock)
			var rock_size := rock.texture.get_size() * rock.scale
			var available_space := CELL_SIZE - rock_size
			
			# Complete this line to calculate a random offset within each rock's grid cell.
			var random_offset
			# Take the random offset into account when placing the rock.
			rock.position = CELL_SIZE * cell
