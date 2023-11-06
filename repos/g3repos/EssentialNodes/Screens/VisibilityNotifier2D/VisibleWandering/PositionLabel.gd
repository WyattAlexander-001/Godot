extends Label

export (NodePath) var node_path
onready var tracking_node := get_node(node_path)


func _process(delta: float) -> void:
	text = "%d, %d" % [tracking_node.global_position.x, tracking_node.global_position.y]
