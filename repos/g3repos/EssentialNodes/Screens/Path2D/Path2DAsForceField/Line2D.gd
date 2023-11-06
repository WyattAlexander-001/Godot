extends Line2D

onready var tip: Polygon2D = $Polygon2DTip


func _process(delta: float) -> void:
	tip.position = points[1]
	tip.rotation = (points[1] - points[0]).angle()
	tip.visible = points[1].distance_to(points[0]) > 0
