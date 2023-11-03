extends Node2D

const MobScene := preload("Mob.tscn")

onready var timer := $Timer
onready var planet := $Planet
onready var mobs_destination: Vector2 = planet.global_position


func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")


func _on_Timer_timeout() -> void:
	var distance: float = mobs_destination.length()
	var direction := Vector2(distance, 0.0).rotated(randf() * 2.0 * PI)
	var mob := MobScene.instance()
	add_child(mob)
	mob.global_position = mobs_destination + direction
	mob.velocity = -1.0 * direction.normalized() * mob.speed
