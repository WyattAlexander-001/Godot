extends Spatial

# Those constants store the indices of the cells we work with.
const SOLID_CELLS := [11, 12, 13]
const FLAT_SOLID_CELL := 12
const DECORATED_SOLID_CELLS := [7, 6, 17]
const TREE_CELLS := [3, 4, 5]
const DECORATION_CELLS := [0, 1, 2]
const PROBABILISTIC_CELL := 9
const EMPTY_CELL := -1

# Probability to replace a grey cell with a tree.
export(float, 0.0, 1.0) var probabilistic_cell_chance := 0.45
# Probability to place a decoration over floor cells.
export(float, 0.0, 1.0) var decoration_chance := 0.2

onready var _gridmap: GridMap = $GridMap

onready var _probabilistic_cells := find_probabilistic_cells()


func _ready() -> void:
	randomize()
	generate_random_map()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		reset_map()
		generate_random_map()
	if event.is_action_pressed("interact"):
		reset_map()
		_show_probabilistic_cells()


func find_probabilistic_cells() -> Array:
	var cells := []
	for cell in _gridmap.get_used_cells():
		if is_cell_of_type(cell, PROBABILISTIC_CELL):
			cells.append(cell)
	return cells


## Replaces one cell with a random one from the `possible_tiles` array.
func randomize_cell(cell: Vector3, possible_tiles: Array) -> void:
	var tile: int = possible_tiles[randi() % possible_tiles.size()]
	_gridmap.set_cell_item(cell.x, cell.y, cell.z, tile)


func is_cell_of_type(cell: Vector3, type: int) -> bool:
	return _gridmap.get_cell_item(cell.x, cell.y, cell.z) == type


func is_cell_in_group(cell: Vector3, group: Array) -> bool:
	return _gridmap.get_cell_item(cell.x, cell.y, cell.z) in group


func reset_map() -> void:
	for cell in _gridmap.get_used_cells():
		var cell_type := _gridmap.get_cell_item(cell.x, cell.y, cell.z)
		if cell_type in SOLID_CELLS:
			continue
		
		# We replace any decorated floor cells with their plain counterpart.
		if cell_type in DECORATED_SOLID_CELLS:
			# The orientation of the replacement floor cell needs to match the decorated one.
			var cell_orientation := _gridmap.get_cell_item_orientation(cell.x, cell.y, cell.z)
			var solid_replacement: int = SOLID_CELLS[DECORATED_SOLID_CELLS.find(cell_type)]
			_gridmap.set_cell_item(cell.x, cell.y, cell.z, solid_replacement, cell_orientation)
		# We erase any trees and rocks.
		else:
			_gridmap.set_cell_item(cell.x, cell.y, cell.z, EMPTY_CELL)


func generate_random_map() -> void:
	_randomize_probabilistic_cells()
	_add_random_cell_decorations()
	_add_random_additional_decorations()


func _randomize_probabilistic_cells() -> void:
	for cell in _probabilistic_cells:
		if randf() < probabilistic_cell_chance:
			randomize_cell(cell, TREE_CELLS)
		else:
			_gridmap.set_cell_item(cell.x, cell.y, cell.z, EMPTY_CELL)


func _add_random_cell_decorations() -> void:
	for cell in _gridmap.get_used_cells():
		if not is_cell_in_group(cell, SOLID_CELLS) or randf() > decoration_chance:
			continue
		
		# As we can rotate tiles in the editor, we need to copy the existing
		# cell's orientation.
		var cell_orientation := _gridmap.get_cell_item_orientation(cell.x, cell.y, cell.z)
		var cell_type := _gridmap.get_cell_item(cell.x, cell.y, cell.z)
		# We arranged our constant arrays so the tile indices in `SOLID_CELLS`
		# match the decorated variant in `DECORATED_SOLID_CELLS`.
		var decorated_replacement: int = DECORATED_SOLID_CELLS[SOLID_CELLS.find(cell_type)]
		_gridmap.set_cell_item(
			cell.x, cell.y, cell.z, decorated_replacement, cell_orientation
		)


func _add_random_additional_decorations() -> void:
	for cell in _gridmap.get_used_cells():
		var cell_above: Vector3 = cell + Vector3.UP
		var can_decorate := (
			is_cell_of_type(cell, FLAT_SOLID_CELL)
			and is_cell_of_type(cell_above, EMPTY_CELL)
		)
		if not can_decorate or randf() > decoration_chance:
			continue

		randomize_cell(cell_above, DECORATION_CELLS)


func _show_probabilistic_cells():
	for cell in _probabilistic_cells:
		_gridmap.set_cell_item(cell.x, cell.y, cell.z, PROBABILISTIC_CELL)
