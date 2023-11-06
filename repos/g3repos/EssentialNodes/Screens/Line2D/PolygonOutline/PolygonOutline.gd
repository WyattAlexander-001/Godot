extends Node2D

export var triangle: ConvexPolygonShape2D
export var square: ConvexPolygonShape2D
export var pentagon: ConvexPolygonShape2D
export var hexagon: ConvexPolygonShape2D

var colors := [
	NodeEssentialsPalette.COLOR_INTERACT,
	NodeEssentialsPalette.COLOR_COLLECTIBLE,
	NodeEssentialsPalette.COLOR_HITBOX,
	NodeEssentialsPalette.COLOR_HURTBOX
]

var shape_list: Array

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _anim_list: Array = _animation_player.get_animation_list()
onready var _line: Line2D = $Polygon2D/Line2D
onready var _polygon: Polygon2D = $Polygon2D
onready var _button: Button = $TextButton


func _ready() -> void:
	randomize()
	_button.connect("pressed", self, "update_shape")
	shape_list = [triangle, square, pentagon, hexagon]
	update_shape()


func update_shape() -> void:
	# Randomize color list
	shape_list.shuffle()
	_anim_list.shuffle()
	_animation_player.stop(true)
	_animation_player.play(_anim_list.front())
	# Randomize color for polygon and line
	var random_index := rand_range(0, colors.size())
	_polygon.color = colors[random_index]
	_line.default_color = colors[wrapi(random_index + 1, 0, colors.size())]
	# Give the polygon the new points and update the line to the same
	_polygon.polygon = shape_list.front().points
	_line.points = _polygon.polygon
