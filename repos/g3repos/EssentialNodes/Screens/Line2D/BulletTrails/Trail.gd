extends Line2D

export var max_points := 16
export var target_path: NodePath

onready var target: Node2D = get_node_or_null(target_path)
onready var _timer: Timer = $Timer


func _ready() -> void:
	_timer.connect("timeout", self, "update_trail")
	set_as_toplevel(true)
	position = target.global_position
func update_trail() -> void:
	add_point(to_local(target.global_position))
	if get_point_count() > max_points:
		remove_point(0)
