class_name DebuggerActor
extends Node2D

onready var current_tile: Vector2


func _ready() -> void:
	current_tile = (position / 64).floor()
	position = current_tile * 64
	z_index = current_tile.y


func move(tile: Vector2, grid_size: Vector2) -> void:
	if tile.x < 0 or tile.x >= grid_size.x or tile.y < 0 or tile.y >= grid_size.y:
		return

	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", tile * 64, 0.2)
	current_tile = tile
	z_index = current_tile.y
