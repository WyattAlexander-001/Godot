extends FPSPlayer

onready var _targetting_ray: RayCast = $TiltPivot/Camera/RayCast
onready var _crosshair: TextureRect = $WeaponReticle/Reticle

onready var _airstrike: Spatial = $Airstrike
onready var _airstrike_animation: AnimationPlayer = $Airstrike/AnimationPlayer

var _last_collider: Enemy3D = null
var _target: Enemy3D = null


func _ready() -> void:
	_airstrike.set_as_toplevel(true)

func _physics_process(delta: float) -> void:
	if _targetting_ray.get_collider() is Enemy3D:
		_last_collider = _targetting_ray.get_collider()
		_crosshair.modulate.a = 1.0
		_last_collider.highlight()
	else:
		_crosshair.modulate.a = 0.333
		_last_collider = null
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_3d") and _last_collider:
		# In this scene all Enemy3D scenes have a RemoteTransform child.
		var enemy_remote = _last_collider.get_node("RemoteTransform")
		for node in get_tree().get_nodes_in_group("airstrike_remote"):
			node.remote_path = ""
		enemy_remote.remote_path = _airstrike.get_path()
		_airstrike_animation.play("Airstrike")
		_target = _last_collider

func damage_target() -> void:
	if is_instance_valid(_target):
		_target.queue_free()
		_target = null
