extends Node2D

# This constant is the size of each grid cell in pixels.
const CELL_SIZE := Vector2(128, 128)

# We use the `ROCKS` array to pick a random scene to vary the visuals that we
# place on the grid.
const ROCKS := [
	preload("rocks/Rock1.tscn"),
	preload("rocks/Rock2.tscn"),
	preload("rocks/Rock3.tscn"),
]

func _ready() -> void:
	# Start by refreshing the seed value used to generate random numbers so we
	# get different random values for each run.
	randomize()
	add_rocks_on_grid(9, 5)


# Creates and places a random rock on each cell of the grid, based on the number
# of columns and rows.
func add_rocks_on_grid(columns: int, rows: int) -> void:
	for column in range(columns):
		for row in range(rows):
			var cell := Vector2(column, row)
			var rock := get_random_rock()
			add_child(rock)
			rock.position = CELL_SIZE * cell


# Creates and returns a new random rock instance.
func get_random_rock() -> Sprite:
	# We first calculate a random index in the ROCKS array.
	var rock_random_index := randi() % ROCKS.size()
	# Then, we get the preloaded scene in the array and create a new instance of
	# it.
	return ROCKS[rock_random_index].instance()
