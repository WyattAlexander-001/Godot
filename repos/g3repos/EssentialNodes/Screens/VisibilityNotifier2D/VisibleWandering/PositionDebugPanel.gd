extends Panel

export var node_path := NodePath()
onready var node := get_node(node_path)

onready var position_label: Label = $PositionLabel


func _process(delta: float) -> void:
	var text := "%d, %d" % [node.global_position.x, node.global_position.y]
	position_label.text = text
