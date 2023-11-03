extends Node2D

const MobScene := preload("Mob.tscn")

var max_mob := 3

onready var timer := $Timer
onready var line := $Line2D
onready var spawn := $SpawnPoint

func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")
	_on_Timer_timeout()


func _on_Timer_timeout() -> void:
	var mob := MobScene.instance()
	spawn.add_child(mob)
	mob.line = line
	max_mob -= 1
	if max_mob == 0:
		timer.stop()
