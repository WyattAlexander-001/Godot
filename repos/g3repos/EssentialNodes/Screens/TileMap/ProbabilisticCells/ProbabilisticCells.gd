extends Node2D

enum Tiles {
	EMPTY_TILE = -1,
	CHANCE_TILE = 0,
	SOLID_TILE = 1,
	DECOR_SOLID = 2,
	DECOR_CEILING1 = 3,
	DECOR_CEILING2 = 4
}

const SOLID_TILE_TYPES := [Tiles.SOLID_TILE, Tiles.DECOR_SOLID]

onready var tilemap: TileMap = $TileMap
onready var tiles: TileSet = tilemap.tile_set


func _ready():
	randomize()
	randomize_chance_tiles()
	add_random_wall_decorations()
	for tile_type in SOLID_TILE_TYPES:
		add_random_ceiling_decorations(tile_type)


func randomize_chance_tiles() -> void:
	for cell in tilemap.get_used_cells_by_id(Tiles.CHANCE_TILE):
		var cell_type: int = Tiles.SOLID_TILE if randf() < 0.25 else Tiles.EMPTY_TILE
		tilemap.set_cellv(cell, cell_type)


func add_random_wall_decorations() -> void:
	for cell in tilemap.get_used_cells_by_id(Tiles.SOLID_TILE):
		if randf() < 0.1:
			tilemap.set_cellv(cell, Tiles.DECOR_SOLID)


func add_random_ceiling_decorations(tile_type: int) -> void:
	for cell in tilemap.get_used_cells_by_id(tile_type):
		var cell_below = cell + Vector2.DOWN
		if tilemap.get_cellv(cell_below) != Tiles.EMPTY_TILE:
			continue

		var random_chance := randf()
		if random_chance < 0.1:
			tilemap.set_cellv(cell_below, Tiles.DECOR_CEILING1)
		elif random_chance < 0.2:
			tilemap.set_cellv(cell_below, Tiles.DECOR_CEILING2)
