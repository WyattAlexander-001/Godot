extends Node2D

export var can_cancel := true

onready var _anim_player := $AnimationPlayer
onready var _skin_anim := $PlayerSideSkin/AnimationPlayer


func _ready() -> void:
	_skin_anim.play("idle")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_anim_player.play("charge")
		
	# Resets the character's pose
	if event.is_action_released("shoot") and can_cancel:
		_anim_player.play("RESET")
