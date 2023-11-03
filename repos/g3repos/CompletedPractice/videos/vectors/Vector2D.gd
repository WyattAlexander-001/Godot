# Draws a vector.
tool
class_name Vector2D
extends Node2D

const CIRCLE_VERTEX_COUNT := 64
const DEFAULT_LINE_THICKNESS := 4.0
const DEFAULT_COLOR := Color(0.960784, 0.980392, 0.980392)

export var color := DEFAULT_COLOR
export var vector := Vector2.ZERO setget set_vector


func _draw() -> void:
	draw_line(Vector2.ZERO, vector, color, DEFAULT_LINE_THICKNESS)
	draw_circle(Vector2.ZERO, 10, color)
	if vector.length_squared() > 0.1:
		draw_triangle(vector, vector.angle() + PI, 10, color)


func set_vector(value: Vector2) -> void:
	vector = value
	update()


func draw_triangle(center := Vector2.ZERO, angle := 0.0, radius := 10.0, color := DEFAULT_COLOR) -> void:
	var points := PoolVector2Array()
	var colors := PoolColorArray([color])
	for i in range(3):
		var angle_point := angle + i * 2.0 * PI / 3.0 + PI
		var offset := Vector2(radius * cos(angle_point), radius * sin(angle_point))
		var point := center + offset
		points.append(point)
	draw_polygon(points, colors)


func draw_circle_outline(
	position := Vector2.ZERO, radius := 30.0, color := Color(), thickness := 1.0
) -> void:
	var points_array := PoolVector2Array()
	for i in range(CIRCLE_VERTEX_COUNT + 1):
		var angle := 2 * PI * i / CIRCLE_VERTEX_COUNT
		var point := position + Vector2(cos(angle) * radius, sin(angle) * radius)
		points_array.append(point)
	draw_polyline(points_array, color, thickness, true)
