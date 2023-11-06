extends Spatial

## This is the path to the target portal we want to connect to this one.
export var target_path := NodePath()
## And this is the path to the player's camera/
export var player_camera_path := NodePath()

var _target: Spatial
var _player_camera: Spatial

## This portal's camera, which we place at the target portal's location.
onready var _camera: Camera = $Viewport/Camera


func _ready() -> void:
	_target = get_node(target_path)
	_player_camera = get_node(player_camera_path)


func _physics_process(_delta: float) -> void:
	# We calculate the player's offset from the portal.
	var player_offset := to_local(_player_camera.global_transform.origin)
	# Then, we place the camera at the target portal and apply the player's offset.
	_camera.transform.origin = _target.global_transform.origin + player_offset
	
	# For the rotation, similarly, we calculate the rotational offset between the portal and the player.
	var local_rotation := global_transform.basis.inverse() * _player_camera.global_transform.basis
	# Then, we add that rotation to the target portal's current rotation.
	_camera.global_transform.basis = _target.transform.basis * local_rotation
