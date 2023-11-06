extends RigidBody

export var camera_path: NodePath

onready var camera: Spatial = get_node(camera_path) as Spatial
