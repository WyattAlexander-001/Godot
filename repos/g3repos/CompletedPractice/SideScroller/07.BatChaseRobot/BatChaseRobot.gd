extends KinematicBody2D

# Will store the robot when it enters the Area2D.
var target: KinematicBody2D

# The Area2D that detects the player.
onready var aggro_area := $AggroArea

export var max_speed := 300.0
export var drag_factor := 0.1

var velocity := Vector2.ZERO


func _ready() -> void:
	aggro_area.connect("body_entered", self, "_on_player_entered")
	aggro_area.connect("body_exited", self, "_on_player_exited")

func _physics_process(delta: float) -> void:
	var direction := Vector2.UP
	if target:
		direction = to_local(target.global_position).normalized()

	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	
	velocity = move_and_slide(velocity)

func _on_player_entered(robot: KinematicBody2D) -> void:
	# Sets the target to the robot when it enters the Area2D.
	target = robot


func _on_player_exited(robot: KinematicBody2D) -> void:
	# When the robot exits the Area2D, the target is out of range.
	target = null
