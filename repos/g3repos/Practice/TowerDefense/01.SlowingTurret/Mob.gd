extends KinematicBody2D

var line: Line2D
var speed := 800.0

onready var animation_player := $AnimationPlayer

var velocity := Vector2.ZERO
var point_index := 6
var target := Vector2()

func _ready() -> void:
	if not line:
		push_error("Line is not specified.")
		return
	target = line.to_global(line.points[6])
	global_position = target


func _physics_process(_delta: float) -> void:
	if not line:
		return
	if global_position.distance_to(target) < 10:
		point_index = (point_index + 1) % line.points.size()
	target = line.to_global(line.points[point_index])
	var del := target - global_position
	var angle := del.angle()
	rotation = lerp_angle(rotation, angle, .3)
	velocity = del.normalized() * speed
	velocity = move_and_slide(velocity)


func take_damage() -> void:
	animation_player.play("take_damage")
