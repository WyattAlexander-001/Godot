extends Node2D

onready var _claw: Area2D = $Claw
onready var _arm: Line2D = $Arm

onready var _remote: RemoteTransform2D = $Claw/RemoteTransform2D
onready var _animation_player: AnimationPlayer = $AnimationPlayer

onready var _button: Button = $Button


func _ready() -> void:
	_button.connect("pressed", self, "animate_claw")
	_claw.connect("body_entered", self, "pickup")


# We use `_process()` only to update the line, to make the arm and base look
# connected.
func _process(_delta: float) -> void:
	_arm.points[1] = _claw.position


# As you saw in pickup
func animate_claw() -> void:
	# Using the `queue()` function on the AnimationPlayer lets us play two
	# animations in sequence as soon as the first finishes.
	_animation_player.queue("move_claw")
	_animation_player.queue("move_base")


func pickup(body: RigidBody2D) -> void:
	var is_busy: bool = _animation_player.current_animation == "move_base" or _remote.remote_path != ""
	if is_busy or not body.is_in_group("ball"):
		return
	# Setting the mode to kinematic allows us to control the body's position.
	body.set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	# We turn off collisions for the ball.
	body.collision_layer = 0
	body.collision_mask = 0
	_remote.remote_path = body.get_path()


func drop() -> void:
	var body: RigidBody2D = get_node(_remote.remote_path)
	if body == null:
		return
	# We set the mode back to rigid so the ball falls and rolls, and we reset its collisions.
	body.set_deferred("mode", RigidBody2D.MODE_RIGID)
	body.linear_velocity = Vector2.ZERO
	body.collision_layer = 1
	body.collision_mask = 1
	_remote.remote_path = ""
