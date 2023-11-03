extends Node2D


const ROCKS := [
	preload("rocks/Rock1.tscn"),
	preload("rocks/Rock2.tscn"),
	preload("rocks/Rock3.tscn"),
]

const CELL_SIZE := Vector2(128, 128)


func _ready() -> void:
	randomize()
	add_rocks_on_grid(9, 5)


# Calculates the offset of each grid cell and a small random vector amount to
# instantiate a rock `Sprite` positioned at that location.
func add_rocks_on_grid(columns: int, rows: int) -> void:
	for column in range(columns):
		for row in range(rows):
			var cell := Vector2(column, row)
			var rock := get_random_rock()
			add_child(rock)

			var rock_size := rock.scale * rock.texture.get_size()
			# This is the maximum offset in pixels we can apply to a given rock
			# based on its size.
			var available_space := CELL_SIZE - rock_size
			# We want the offset to be random both on the X and Y axes so we
			# call randf() twice. The randf() function generates a random number
			# between 0.0 and 1.0.
			var random_offset := Vector2(randf(), randf()) * available_space
			rock.position = CELL_SIZE * cell + random_offset


func get_random_rock() -> Sprite:
	var rock_random_index := randi() % ROCKS.size()
	return ROCKS[rock_random_index].instance()
