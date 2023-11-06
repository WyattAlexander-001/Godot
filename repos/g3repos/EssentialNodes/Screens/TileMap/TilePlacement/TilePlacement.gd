extends Node2D

const VALID_TILE_COLOR := Color(0, 1, 0, 0.25)
const INVALID_TILE_COLOR := Color(1, 0, 0, 0.25)
const EMPTY_TILE := -1

var selected_tile := 0 setget set_selected_tile

var _current_cell := Vector2.INF
var _is_hovered_space_empty := false
var _tile_rects := []
var _used_cells := []

onready var _tilemap: TileMap = $TileMap
onready var _preview: Sprite = $Preview
onready var _tiles: TileSet = _tilemap.tile_set

onready var _tile_count = _tiles.get_tiles_ids().size()


func _ready() -> void:
	for tile in _tiles.get_tiles_ids():
		var tile_rect := _tiles.tile_get_region(tile).size / _tilemap.cell_size
		_tile_rects.append(tile_rect)
	update_tilemap(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update_tilemap(event.position)

	if event.is_action_pressed("click") and _is_hovered_space_empty:
		draw_cell()
	elif event.is_action_pressed("right_click"):
		erase_cell()
	elif event.is_action_pressed("wheel_up"):
		set_selected_tile(selected_tile - 1)
	elif event.is_action_pressed("wheel_down"):
		set_selected_tile(selected_tile + 1)


func set_selected_tile(new_tile_id: int) -> void:
	selected_tile = wrapi(new_tile_id, 0, _tile_count)
	_preview.region_rect = _tiles.tile_get_region(selected_tile)
	update_tilemap(get_global_mouse_position())


func update_tilemap(coordinates: Vector2) -> void:
	var offset_coordinates := coordinates - _tilemap.cell_size / 2
	_preview.position = offset_coordinates.snapped(_tilemap.cell_size)
	_preview.modulate = VALID_TILE_COLOR
	_is_hovered_space_empty = true
	_current_cell = _tilemap.world_to_map(coordinates)
	for cell in get_cell_array(_current_cell, selected_tile):
		if _used_cells.has(cell):
			_preview.modulate = INVALID_TILE_COLOR
			_is_hovered_space_empty = false
			break


func draw_cell() -> void:
	_tilemap.set_cellv(_current_cell, selected_tile)
	for cell in get_cell_array(_current_cell, selected_tile):
		if _used_cells.has(cell):
			continue
		_used_cells.append(cell)


func erase_cell() -> void:
	var tile_index := _tilemap.get_cellv(_current_cell)
	if tile_index == EMPTY_TILE:
		return

	for cell in get_cell_array(_current_cell, tile_index):
		_used_cells.erase(cell)
	_tilemap.set_cellv(_current_cell, EMPTY_TILE)


func get_cell_array(cellv: Vector2, tile_index: int) -> Array:
	var cells := []
	for x in _tile_rects[tile_index].x:
		for y in _tile_rects[tile_index].y:
			cells.append(cellv + Vector2(x, y))
	return cells
