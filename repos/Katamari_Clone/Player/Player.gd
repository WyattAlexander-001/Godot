extends RigidBody3D

@export var ballSpeed := 1200
@export var mouse_sensitivity := 0.001
@export var twist_input := 0.0
@export var pitch_input := 0.0
@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot

@onready var mesh_instance_3d = $MeshInstance3D
@onready var collision_shape_3d = $CollisionShape3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hides Mouse On Start

	
func _process(delta: float) -> void:
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.z = Input.get_axis("move_forward", "move_back")

	# Convert the input vector into a direction based on the camera's orientation
	var forward_dir = twist_pivot.global_transform.basis.z.normalized() * 1
	var right_dir = twist_pivot.global_transform.basis.x.normalized()
	var movement_direction = (input_vector.z * forward_dir + input_vector.x * right_dir).normalized()

	# Apply central force in the calculated direction
	apply_central_force(movement_direction * ballSpeed * delta)
	_toggleCursor()
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-15), deg_to_rad(15))
	twist_input = 0.0
	pitch_input = 0.0
	
	_rotate_ball_relative_to_camera(delta)		

func _toggleCursor():
	if Input.is_action_just_pressed("ui_cancel"): # For hitting escape key to toggle mouse cursor
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("left_click") && Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hides cursor upon left click

func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
	
func _rotate_ball_relative_to_camera(delta: float) -> void:
	var rotation_speed = 55.0 
	if Input.is_action_pressed("move_right"):
		mesh_instance_3d.rotate_z(deg_to_rad(-rotation_speed * delta))
		collision_shape_3d.rotate_z(deg_to_rad(-rotation_speed * delta))
	if Input.is_action_pressed("move_left"):
		mesh_instance_3d.rotate_z(deg_to_rad(+rotation_speed * delta))
		collision_shape_3d.rotate_z(deg_to_rad(+rotation_speed * delta))
	if Input.is_action_pressed("move_forward"):  
		mesh_instance_3d.rotate_x(deg_to_rad(-rotation_speed * delta))
		collision_shape_3d.rotate_x(deg_to_rad(-rotation_speed * delta))
	if Input.is_action_pressed("move_back"):  
		mesh_instance_3d.rotate_x(deg_to_rad(+rotation_speed * delta))
		collision_shape_3d.rotate_x(deg_to_rad(+rotation_speed * delta))
