extends Node2D

onready var animation_player := $AnimationPlayer
onready var label := $Label


func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	position.x = rand_range(-32, 32)


func set_amount(amount: float) -> void:
	label.text = str(amount)


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
