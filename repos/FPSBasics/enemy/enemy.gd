extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var animation = $Animation

var player
var provoked := false
var aggro_range := 10.0
@export var attack_range := 1.5

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void: #_delta means optional parameter
	if provoked == true: # Could also use if provoked: since true is implied
		navigation_agent_3d.target_position = player.global_position

func _physics_process(delta: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = global_position.direction_to(next_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= aggro_range:
		provoked = true
	
	if provoked == true and distance <= attack_range:
		print("enemy attack!") # will print every second due to delta, can remove
		animation.play("Attack")
	
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)
	
func attack() -> void:
	print("Hey the enemy ATTACKED!") # will print every 0.2 seconds as per animation
