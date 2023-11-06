extends FPSPlayer

const THROW_FORCE := 240.0
const PICKUP_FORCE := 60.0
const MAX_DISTANCE := 0.33
onready var _raycast: RayCast = $TiltPivot/Camera/RayCast
onready var _pickup: RemoteTransform = $TiltPivot/Camera/Pickup


func _physics_process(delta: float) -> void:
	if _raycast.get_collider() is Interactible3D:
		_pickup.remote_path = _raycast.get_collider().get_path()
		_raycast.get_collider().highlight()
	if _pickup.remote_path:
		var interactible := get_node(_pickup.remote_path)
		var direction = interactible.global_transform.origin.direction_to(
			_pickup.global_transform.origin
		)
		var distance = interactible.global_transform.origin.distance_squared_to(
			_pickup.global_transform.origin
		)

		if Input.is_action_pressed("click"):
			interactible.apply_central_impulse(
				direction * min(distance, MAX_DISTANCE) * PICKUP_FORCE * delta
			)
			interactible.highlight()
			interactible.play(true)
			_raycast.enabled = false
		elif Input.is_action_just_released("click"):
			interactible.apply_central_impulse(direction * THROW_FORCE * delta)
			interactible.play(false)
			_pickup.remote_path = NodePath()
			_raycast.enabled = true
