extends "res://common/PlayerSideScroll/PlayerSideScroll.gd"

onready var _hurt_box: Area2D = $HurtBox
onready var _anim_player_explosion: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_hurt_box.connect("body_entered", self, "_on_Area2D_body_entered")


func _on_Area2D_body_entered(body: Node) -> void:
	if not body.is_class("TileMap"):
		return
	
	if body.is_in_group("Hazard"):
		_anim_player_explosion.queue("explode")
