extends Spatial


onready var _remote_transform: RemoteTransform = $BoardAxis/TiltAxis/RemoteTransform
onready var _bail_timer: Timer = $BailTimer
onready var tilt_axis: Spatial = $BoardAxis/TiltAxis
onready var board: Spatial = $BoardAxis
onready var ball: RigidBody = $Ball

var skateboarder: RigidBody

var max_board_tilt := 8.0
var max_speed := 36.0
var turn_speed = 42.0
var steering := 5.0


func _ready() -> void:
	_bail_timer.connect("timeout", self, "_on_BailTimer_timeout")
	ball.connect("crash", self, "_on_ball_crash")


func _physics_process(delta: float) -> void:
	var acceleration_input := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	var rotation_input := Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	
	ball.add_central_force(-board.global_transform.basis.z * acceleration_input * max_speed)
	
	# tilt board to indicate turning
	tilt_axis.rotation_degrees.z = lerp(tilt_axis.rotation_degrees.z, rotation_input * max_board_tilt, delta * steering)
	
	var new_basis = board.global_transform.basis.rotated(board.global_transform.basis.y, rotation_input * turn_speed * delta)
	board.global_transform.basis = board.global_transform.basis.slerp(new_basis, delta * steering)
	board.global_transform = board.global_transform.orthonormalized()
	

func _on_ball_crash(collision_point: Vector3) -> void:
	if _remote_transform.remote_path.is_empty():
		return
	skateboarder = _remote_transform.get_node(_remote_transform.remote_path)
	skateboarder.camera.set_physics_process(false)
	set_physics_process(false)
	# Disable the player remote, so the ragdoll is free to fall.
	_remote_transform.remote_path = ""
	# Apply a force in the direction of the collision to the ragdoll.
	skateboarder.apply_central_impulse(collision_point)
	# Start the cooldown to reset the ragdoll.
	_bail_timer.start()

# Reset the ragdoll to be connected to the remote and re-enable player control.
func _on_BailTimer_timeout() -> void:
	skateboarder.linear_velocity = Vector3.ZERO
	_remote_transform.remote_path = _remote_transform.get_path_to(skateboarder)
	set_physics_process(true)
	skateboarder.camera.set_physics_process(true)
