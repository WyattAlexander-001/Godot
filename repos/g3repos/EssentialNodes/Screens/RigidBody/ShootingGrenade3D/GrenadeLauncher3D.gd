extends Spatial

export var camera_raycast_path: NodePath
export var grenade_scene: PackedScene
export var launch_impulse := 2.0

onready var _timer := $Timer
onready var _camera_raycast: RayCast = get_node(camera_raycast_path) as RayCast


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_3d") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		shoot()


func shoot() -> void:
	if not _timer.is_stopped():
		return
	_timer.start()

	var grenade: RigidBody = grenade_scene.instance()
	add_child(grenade)

	var shoot_direction := _camera_raycast.to_global(_camera_raycast.cast_to).normalized()
	grenade.apply_central_impulse(shoot_direction * launch_impulse)
