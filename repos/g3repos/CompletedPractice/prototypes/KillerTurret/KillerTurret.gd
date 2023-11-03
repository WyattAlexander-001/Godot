extends Node2D

const Bullet := preload("Bullet.tscn")

export var bullets_per_second := 10
export var random_shoot_angle := PI / 6.0

var _cooldown_duration := 1.0 / bullets_per_second

onready var fire_point := $Gun/FirePoint
onready var timer := $Timer


func _ready() -> void:
	timer.wait_time = _cooldown_duration


func _process(_delta: float) -> void:
	var direction := get_global_mouse_position() - global_position
	direction = direction.normalized()
	rotation = direction.angle()
	
	if Input.is_action_pressed("shoot") and timer.is_stopped():
		shoot()


func shoot() -> void:
	var new_bullet = Bullet.instance()
	var direction = Vector2.RIGHT.rotated(rotation + calculate_random_angle(random_shoot_angle))
	new_bullet.setup(direction, fire_point.global_position)
	fire_point.add_child(new_bullet)
	timer.start()


func calculate_random_angle(max_angle: float) -> float:
	return rand_range(-max_angle / 2.0, max_angle / 2.0)
