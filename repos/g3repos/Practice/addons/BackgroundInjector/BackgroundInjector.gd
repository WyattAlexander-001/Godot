# Injects a background into any scene except for the game's entry point.
tool
extends Node

# Associates each background scene resource to a shorter name.
const BACKGROUNDS := {
	space = preload("backgrounds/SpaceBackground.tscn"),
}
const DEFAULT := BACKGROUNDS.space

# Maps filenames to a key in the BACKGROUNDS constant.
const FILE_MAP := {
	"SelfMovingShip.gd": "space",
	"ShipWithInput.gd": "space",
	"BoostingShip.gd": "space",
	"SteeringShip.gd": "space",
	"TouchShip.gd": "space",
}

var canvas_layer := CanvasLayer.new()


func _ready() -> void:
	canvas_layer.layer = -100
	canvas_layer.name = "Background"
	var background := _get_background_resource().instance()
	canvas_layer.add_child(background)
	yield(get_viewport(), "ready")
	get_viewport().add_child(canvas_layer)


func _get_background_resource() -> PackedScene:
	var last_child := get_viewport().get_child(get_viewport().get_child_count() - 1)
	var script = last_child.get_script()
	if not script:
		return DEFAULT

	var script_path: String = last_child.get_script().resource_path
	var filename := script_path.rsplit("/", true, 1)[-1]
	if FILE_MAP.has(filename):
		var background_key: String = FILE_MAP[filename]
		return BACKGROUNDS[background_key]
	return DEFAULT
