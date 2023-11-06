extends KinematicBody2D

export var speed := 500.0
export var drag := 4.0

var velocity := Vector2.ZERO

onready var _skin := $PlayerSideSkin as Node2D
onready var _start_scale_x := _skin.scale.x

onready var _anim_player := $PlayerSideSkin/AnimationPlayer as AnimationPlayer


func _physics_process(_delta: float) -> void:
	var direction := Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()

	var desired_velocity := direction * speed
	var steering := desired_velocity - velocity
	velocity += steering / drag
	velocity = velocity.clamped(speed)

	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI / 4, false)
	
	if abs(direction.x) > 0.1:
		_skin.scale.x = sign(direction.x) * _start_scale_x

	if abs(direction.length_squared()) > 0.1:
		_anim_player.play("run")
	else:
		_anim_player.play("idle")
