## A base class to generate enemies and pickups based on the contents of two
## child Tilemaps.
class_name BaseRoom
extends Node2D

const ENEMY_TILE_ID := 1

var _entrances := []
var _enemies := []

onready var _invisible_walls: TileMap = $InvisibleWalls


func _ready() -> void:
	_invisible_walls.hide()
	for child in get_children():
		if child is RoomEntrance:
			_entrances.append(child)
			child.connect("player_entered", self, "_on_player_entered")
		if child is BaseEnemyAI:
			_enemies.append(child)
			child.connect("died", self, "_on_enemy_died", [child])


func open_entrances() -> void:
	for entrance in _entrances:
		entrance.open()


func close_entrances() -> void:
	for entrance in _entrances:
		entrance.close()


func _on_player_entered() -> void:
	if _enemies.empty():
		return
	for enemy in _enemies:
		enemy.activate()
	close_entrances()


func _on_enemy_died(enemy: Node) -> void:
	_enemies.erase(enemy)
	if _enemies.empty():
		open_entrances()
