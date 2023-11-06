extends "res://common/Spawner/Spawner.gd"

export var cooldown := 0.1

onready var _timer: Timer = $Timer


func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and _timer.is_stopped():
		spawn()
		_timer.start(cooldown)


func spawn() -> Node2D:
	var bullet = .spawn()

	bullet.direction = Vector2.RIGHT.rotated(global_rotation)
	return bullet
