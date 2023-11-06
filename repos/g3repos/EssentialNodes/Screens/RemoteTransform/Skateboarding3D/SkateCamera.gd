extends Spatial

const CAMERA_SPEED := 12.0

export var camera_point_path: NodePath

onready var camera_point: Spatial = get_node(camera_point_path) as Spatial

func _physics_process(delta: float) -> void:
	if camera_point:
		global_transform = global_transform.interpolate_with(
			camera_point.global_transform, delta * CAMERA_SPEED
		)
