# How to use:
#
# Make sure **one and only one** scene is visible under the *Scenes* node and run the code.
extends Node2D


const SCRIPTS := {
	"RegularGrid": preload("res://RandomRocks/01.RegularGrid/RegularGrid.gd"),
	"BlueNoise": preload("res://RandomRocks/01.RegularGrid/RegularGrid.gd"),
	"BlueNoiseMask": preload("res://RandomRocks/03.BlueNoiseMask/BlueNoiseMask.gd"),
}

const Tile := preload("res://videos/blue-noise/BlueNoiseTileVideo.tscn")

var scene: Node2D

onready var scenes: Node2D = $Scenes
onready var timer: Timer = $Timer


func _ready() -> void:
	for node in scenes.get_children():
		if not node.visible: continue
		scene = node
		break
	run()


func run() -> void:
	scene.set_script(SCRIPTS[scene.name])
	funcref(self, "run_" + scene.name.to_lower()).call_func()


func run_regulargrid() -> void:
	scene.add_rocks_on_grid(9, 5)
	set_rocks_invisible()

	for node in scene.get_children():
		if node is Sprite:
			yield(timer, "timeout")
			node.visible = true

			var offset: Vector2 = node.position
			var tile := Tile.instance()
			tile.rect_position = offset
			add_child(tile)


func run_bluenoise() -> void:
	scene.add_rocks_on_grid(9, 5)
	set_rocks_invisible()

	for node in scene.get_children():
		if node is Sprite:
			yield(timer, "timeout")
			node.visible = true

			var cell_size: Vector2 = scene.CELL_SIZE * Vector2.ONE
			var offset: Vector2 = cell_size * (node.position / cell_size).floor()
			var tile := Tile.instance()
			tile.rect_position = offset
			add_child(tile)


func run_bluenoisemask() -> void:
	scene.mask = scene.get_node("Mask")
	scene.mask.visible = false
	scene.add_rocks_on_grid()
	set_rocks_invisible()

	for node in scene.get_children():
		if node is Sprite:
			yield(timer, "timeout")
			node.visible = true

			var offset: Vector2 = node.position - scene.mask.position
			offset = scene.mask.world_to_map(offset)
			offset = scene.mask.map_to_world(offset)
			offset += scene.mask.position
			var tile := Tile.instance()
			tile.rect_position = offset
			add_child(tile)


func set_rocks_invisible() -> void:
	for node in scene.get_children():
		if node is Sprite:
			node.visible = false
