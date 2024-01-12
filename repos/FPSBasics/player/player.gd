extends CharacterBody3D


@export var speed = 10.0
@export var jump_height: float = 2.0
@export var fall_multiplier: float = 2.5
@export var max_hitpoints := 100
@export var aim_multiplier := 0.7
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
@onready var camera_pivot = $CameraPivot
@onready var damage_animation_player = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu = $GameOverMenu
@onready var ammo_handler: Node = %AmmoHandler
@onready var smooth_camera: Camera3D = %SmoothCamera
@onready var smooth_camera_fov := smooth_camera.fov
@onready var weapon_camera: Camera3D = %WeaponCamera
@onready var weapon_camera_fov := weapon_camera.fov

var hitpoints: int = max_hitpoints:
	set(value):
		if value < hitpoints:
			damage_animation_player.stop(false) # Will stop any existing animation
			damage_animation_player.play("TakeDamage")
		hitpoints = value
		print(hitpoints)
		if hitpoints <= 0:
			game_over_menu.game_over()

func _ready()-> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # mouse disappears

func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		smooth_camera.fov = lerp(smooth_camera.fov,smooth_camera_fov * aim_multiplier, delta * 20.0)
		weapon_camera.fov = lerp(weapon_camera.fov,weapon_camera_fov * aim_multiplier, delta * 20.0)
	else:
		smooth_camera.fov = lerp(smooth_camera.fov,smooth_camera_fov, delta * 30.0)
		weapon_camera.fov = lerp(weapon_camera.fov,weapon_camera_fov, delta * 30.0)
	
	
func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	# Add the gravity (downward velocity when player is NOT on floor).
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity) 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if Input.is_action_pressed("aim"):
			velocity.x *= aim_multiplier
			velocity.z *= aim_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion = -event.relative * 0.001	
			if Input.is_action_pressed("aim"):
				mouse_motion *= aim_multiplier
	if event.is_action_pressed("ui_cancel"): # esc key to get pointer
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
		
func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x,-90.0,90.0) #caps view at 90 degrees
	mouse_motion = Vector2.ZERO
