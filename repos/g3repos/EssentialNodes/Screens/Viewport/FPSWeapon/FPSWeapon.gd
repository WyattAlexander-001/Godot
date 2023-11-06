extends Spatial

onready var _beam_mesh: MeshInstance = find_node("BeamMesh")
onready var _blaster: MeshInstance = find_node("blaster")
onready var _blaster_knob: MeshInstance = find_node("blaster_knob")
onready var _blaster_lever: MeshInstance = find_node("blaster_lever")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var target_layer_mask = 2 if _beam_mesh.get_layer_mask() == 1 else 1
		for node in [_beam_mesh, _blaster, _blaster_knob, _blaster_lever]:
			node.set_layer_mask(target_layer_mask)
