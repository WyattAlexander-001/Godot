tool
extends Node2D

export var layer_count := 6
export (float, 0.01, 0.2) var scale_offset := 0.04

onready var _tilemap: TileMap = $SideScrollTileMap


func _ready():
	for index in range(layer_count):
		var canvas := CanvasLayer.new()
		# We place half the layers in front of the player, and half behind behind.
		# That way, the character appears in the middle of the ground.
		canvas.layer = layer_count / 2 - index
		if canvas.layer == 0:
			canvas.layer += 1
		
		canvas.follow_viewport_enable = true
		canvas.follow_viewport_scale = 1.0 + canvas.layer * scale_offset
		add_child(canvas)
		canvas.add_child(_tilemap.duplicate())
