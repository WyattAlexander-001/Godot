extends Area2D

const LOOT_SCENES := [
	preload("res://pickups/WeaponPickup.tscn"),
	preload("res://pickups/HealthPickup.tscn")
]

onready var _animation_player := $AnimationPlayer as AnimationPlayer
onready var _tween := $Tween as Tween
onready var _path_follow := $Path2D/PathFollow2D as PathFollow2D


func _ready() -> void:
	connect("body_entered", self, "_loot")


func _loot(player : KinematicBody2D) -> void:
	set_deferred("monitoring", false)
	_animation_player.play("loot")
	_create_pickup()


func _create_pickup() -> void:
	var loot = LOOT_SCENES[randi() % LOOT_SCENES.size()].instance()
	_path_follow.call_deferred("add_child", loot)
	_tween.interpolate_property(_path_follow, "unit_offset", 0, 1, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.start()
