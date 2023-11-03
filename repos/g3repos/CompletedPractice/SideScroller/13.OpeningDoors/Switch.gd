extends Area2D

export var door_path: NodePath
onready var door := get_node(door_path)


func _ready() -> void:
	connect("body_entered", self, "_activate_door")
	connect("body_exited", self, "_activate_door")


func _activate_door(body: Node) -> void:
	door.activate()
