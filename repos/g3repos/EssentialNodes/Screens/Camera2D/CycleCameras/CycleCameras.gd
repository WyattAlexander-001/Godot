extends Node2D

var _cameras := []
var _current_camera: Camera2D


func _ready() -> void:
	_cameras = get_tree().get_nodes_in_group("cameras")
	_current_camera = _cameras[0]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		cycle_cameras()


func cycle_cameras() -> void:
	_cameras.push_back(_cameras.pop_front())
	_current_camera = _cameras[0]
	_current_camera.current = true
