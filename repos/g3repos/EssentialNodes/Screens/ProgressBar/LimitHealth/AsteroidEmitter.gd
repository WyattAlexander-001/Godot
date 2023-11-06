extends Node2D

export var asteroid: PackedScene

onready var _timer: Timer = $Timer


func _ready() -> void:
	randomize()
	_timer.connect("timeout", self, "_on_Timer_timeout")


func _on_Timer_timeout() -> void:
	shoot()


func shoot() -> void:
	var new_asteroid = asteroid.instance()
	new_asteroid.direction = Vector2(rand_range(-1.0, 1.0), 1.0).normalized()
	add_child(new_asteroid)
