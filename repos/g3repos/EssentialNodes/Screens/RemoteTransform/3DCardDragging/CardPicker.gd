extends RemoteTransform

export var _cards_path: NodePath
export var _camera_path: NodePath
export var smoothing := 0.1

onready var cards: Array = get_node_or_null(_cards_path).get_children()
onready var _camera_node: Camera = get_node(_camera_path)


func _ready() -> void:
	set_process(false)
	for card in cards:
		card.connect("input_event", self, "_on_Card_input_event", [card])


func _process(delta: float) -> void:
	var mouse_position = get_plane_mouse_position()
	global_transform.origin.x = lerp(global_transform.origin.x, mouse_position.x, delta / smoothing)
	global_transform.origin.z = lerp(global_transform.origin.z, mouse_position.y, delta / smoothing)


func set_remote_node(path: NodePath) -> void:
	var selected_card = get_node_or_null(remote_path)
	if path:
		get_node(path).save_base_height()
	set_process(not path.is_empty())
	remote_path = path
	if path.is_empty() and selected_card:
		selected_card.reset_height()


func get_plane_mouse_position() -> Vector2:
	var mouse_position = get_viewport().get_mouse_position()
	var drop_plane = Plane(Vector3.UP, translation.y)
	var position_in_world = drop_plane.intersects_ray(
		_camera_node.project_ray_origin(mouse_position),
		_camera_node.project_ray_normal(mouse_position)
	)
	return Vector2(position_in_world.x, position_in_world.z)


func _on_Card_input_event(
	_camera: Node,
	event: InputEvent,
	_click_position: Vector3,
	_click_normal: Vector3,
	_shape_idx: int,
	card_reference: Area
) -> void:
	if event.is_action_pressed("click"):
		var mouse_position := get_plane_mouse_position()
		global_transform.origin.x = mouse_position.x
		global_transform.origin.z = mouse_position.y
		set_remote_node(card_reference.get_path())
		
func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		set_remote_node("")
