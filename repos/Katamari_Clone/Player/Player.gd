extends RigidBody3D

@export var ballSpeed := 1200
@export var mouse_sensitivity := 0.001
@export var twist_input := 0.0
@export var pitch_input := 0.0
@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hides Mouse On Start

	
func _process(delta: float) -> void:

	
	
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left","move_right")
	input.z = Input.get_axis("move_forward","move_back")
	apply_central_force(twist_pivot.basis * input * ballSpeed * delta)
	
	
	_toggleCursor()
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-15),deg_to_rad(15))
	twist_input = 0.0
	pitch_input = 0.0

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
	
