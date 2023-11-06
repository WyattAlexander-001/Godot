extends FPSPlayer
export var security_camera_nodepath: NodePath

onready var _security_camera: Camera = get_node(security_camera_nodepath)
onready var _crt_animator: AnimationPlayer = $TiltPivot/Camera/CanvasLayer/AnimationPlayer
onready var _interaction_timer: Timer = $InteractionTimer
onready var _camera: Camera = $TiltPivot/Camera
onready var _raycast: RayCast = $TiltPivot/Camera/RayCast
onready var _animator: AnimationPlayer = $AnimationPlayer



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if _security_camera.current:
			reset_to_player_camera()
		elif _camera.current and can_see_monitor():
			view_through_security_camera()


func _physics_process(delta: float) -> void:
	if can_see_monitor():
		if _animator.current_animation_position == 0.0:
			_animator.play("Popup")
	elif _animator.current_animation_position > 0.0:
		_animator.seek(0.0, true)

func view_through_security_camera() -> void:
	if not _interaction_timer.is_stopped():
		return

	_crt_animator.play("SwapToSecurityCamera")
	_security_camera.current = true


func reset_to_player_camera() -> void:
	_crt_animator.play("RESET")
	_camera.current = true
	_interaction_timer.start()

func can_see_monitor() -> bool:
	if _raycast.is_colliding():
		if _raycast.get_collider().is_in_group("monitor"):
			return true
	return false
