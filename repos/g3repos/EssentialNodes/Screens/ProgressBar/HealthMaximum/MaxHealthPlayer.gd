extends Node2D

const MAX_HEALTH := 300

onready var _player: KinematicBody2D = $PlayerSideScroll
onready var _collision_area: Area2D = $PlayerSideScroll/Area2D

onready var _health_bar: ProgressBar = $CanvasLayer/MarginContainer/VBoxContainer/ProgressBar
onready var _health_tween: Tween = $CanvasLayer/MarginContainer/VBoxContainer/ProgressBar/Tween

onready var _anim_player: AnimationPlayer = $PlayerSideScroll/PlayerSideSkin/AnimationPlayer

func _ready() -> void:
	_collision_area.connect("area_entered", self, "_on_Area2D_area_entered")


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("pickup"):
		increase_max_health(area.health_given)
		area.pickup()

func increase_max_health(amount: int) -> void:
	if _health_bar.max_value >= MAX_HEALTH:
		return
	
	_health_tween.interpolate_property(
		_health_bar,
		"max_value",
		_health_bar.max_value,
		_health_bar.max_value + amount,
		0.5,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	
	_health_tween.interpolate_property(
		_health_bar,
		"rect_min_size:x",
		_health_bar.rect_min_size.x,
		(_health_bar.max_value + amount) * 5,
		0.5,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	_health_tween.start()
