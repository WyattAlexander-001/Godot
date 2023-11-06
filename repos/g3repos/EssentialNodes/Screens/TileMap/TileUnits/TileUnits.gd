extends Node2D

export var unit_to_instance: PackedScene

enum {
	UNIT_PREVIEW_TILE = 0,
	EMPTY_TILE = -1,
}

# The TileMap is used to show a preview cursor. Used in update_tilemap_preview().
var preview_cursor_position := Vector2.ZERO

# Holds our cursor, as well as other building tiles that already occupy the grid.
onready var tilemap: TileMap = $TileMap


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update_tilemap_preview(event.position)
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			create_unit_at(event.position)


## Places a PackedScene, with its position snapped to the TileMap.
func create_unit_at(coordinates: Vector2) -> void:
	# Snap input coordinates to the TileMap.
	var map_position := tilemap.world_to_map(coordinates)
	var selected_tile := tilemap.get_cellv(map_position)
	# If update_tilemap_preview() didn't put the cursor here, don't put a unit here either.
	if selected_tile != UNIT_PREVIEW_TILE:
		return
	var new_unit := unit_to_instance.instance()
	# Get a world position out of the map so our unit placement matches the grid.
	new_unit.position = tilemap.map_to_world(map_position)
	add_child(new_unit)


## Updates the preview cursor, checks if it would overlap an already-occupied tile.
func update_tilemap_preview(coordinates: Vector2) -> void:
	# Don't show the preview over an existing tile.
	if tilemap.get_cellv(tilemap.world_to_map(coordinates)) != EMPTY_TILE:
		return
	# Empty the previous cursor position.
	tilemap.set_cellv(preview_cursor_position, EMPTY_TILE)
	# Update the cursor position.
	preview_cursor_position = tilemap.world_to_map(coordinates)
	# Use the cursor position to place the unit preview tile.
	tilemap.set_cellv(preview_cursor_position, UNIT_PREVIEW_TILE)
