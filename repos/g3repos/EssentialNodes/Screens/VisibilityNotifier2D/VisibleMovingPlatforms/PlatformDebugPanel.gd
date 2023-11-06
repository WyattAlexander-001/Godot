extends Panel

export (NodePath) var path_to_node
onready var node := get_node(path_to_node)

onready var position_label: Label = $PositionLabel


func _process(delta: float) -> void:
	var position: Vector2 = node.global_position
	var text := "%d, %d" % [position.x, position.y]
	position_label.text = text
