extends "res://common/PlayerSideScroll/SidescrollerRigidBody2D.gd"

onready var _balloon := $Balloon
onready var _joint := $SpringJoint2D


func _ready() -> void:
	_joint.node_a = ""
	remove_child(_balloon)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_balloon"):
		if not _balloon in get_children():
			add_child(_balloon)
			_balloon.global_position = global_position + Vector2.UP * 150
			_balloon.spawn()
			_joint.node_a = _joint.get_path_to(_balloon)
	elif event.is_action_released("use_balloon"):
		if _balloon in get_children():
			_joint.node_a = ""
			remove_child(_balloon)
