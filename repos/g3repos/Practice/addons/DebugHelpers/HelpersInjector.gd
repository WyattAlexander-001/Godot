extends Node

const CircleDebug := preload("GDQuestCollisionCircleDebugDraw.gd")

func _ready() -> void:
	yield(get_tree().root, "ready")
	# find_nodes_of_type(get_tree().root)


func find_nodes_of_type(root: Node) -> void:
	for child in root.get_children():
		find_nodes_of_type(child)
	if root is CollisionShape2D and root.shape is CircleShape2D:
		var circle_debug := CircleDebug.new()
		circle_debug.collision_shape = root
		root.get_parent().add_child(circle_debug)
		circle_debug.visible = root.visible
