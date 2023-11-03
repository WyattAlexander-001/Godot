# draws a dashed circle if it has the path to a CollisionShape2D that has a CircleShape
# shape
# uses its direct collision_shape if a path is not specified
# Disappears in an exported game, only shows in the editor and the development game
class_name GDQuestCollisionCircleDebugDraw
extends Node2D

export var collision_shape_path: NodePath setget set_collision_shape_path

var collision_shape: CollisionShape2D

func _ready() -> void:
	var node = get_parent() if not collision_shape_path else get_node(collision_shape_path)
	_set_collision_shape(node)


func _process(_delta: float) -> void:
	update()


func _draw() -> void:
	if not OS.is_debug_build():
		return
	if collision_shape:
		var shape_radius := (collision_shape.shape as CircleShape2D).radius
		var width:= round((shape_radius * 2) / 100)
		draw_circle_arc(shape_radius, Color.white, width)


func draw_circle_arc(radius: float, color := Color.white, width := 1.0, center := Vector2(), angle_from := 0.0, angle_to:= PI * 2, nb_points := 0):
	if nb_points == 0:
		nb_points = int(radius / 2)
	var increment := (angle_to - angle_from) / nb_points
	var points_arc = PoolVector2Array()

	for i in range(nb_points+1):
		var angle_point := i * increment + angle_from
		var point := center + Vector2(cos(angle_point), sin(angle_point)) * radius
		points_arc.push_back(point)

	for index_point in range(nb_points):
		if index_point % 2 == 0:
			continue
		var from: Vector2 = points_arc[index_point]
		var to: Vector2 = points_arc[index_point + 1]
		draw_line(from, to, color, width, true)


func set_collision_shape_path(new_path: NodePath) -> void:
	collision_shape_path = new_path
	_set_collision_shape(get_node(collision_shape_path))


func _set_collision_shape(new_collision_shape: Node) -> void:
	if not (new_collision_shape is CollisionShape2D):
		return
	var shape := (new_collision_shape as CollisionShape2D).shape
	if not (shape is CircleShape2D):
		return
	var shape_radius := (shape as CircleShape2D).radius
	if shape_radius <= 0:
		return
	collision_shape = new_collision_shape
	update()
