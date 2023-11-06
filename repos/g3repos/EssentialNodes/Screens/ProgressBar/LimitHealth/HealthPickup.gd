class_name HealthKit
extends Area2D

const PLAYER_LAYER := 0

export var health_given: int = 50

onready var _anim_player: AnimationPlayer = $AnimationPlayer

func pickup() -> void:
	set_collision_layer_bit(PLAYER_LAYER, false)
	_anim_player.stop()
	_anim_player.queue("collected")
	_anim_player.queue("delay")
	_anim_player.queue("respawn")

func respawn() -> void:
	set_collision_layer_bit(PLAYER_LAYER, true)
	_anim_player.play("idle")
