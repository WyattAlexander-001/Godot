extends Area2D


onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")


func _on_area_entered(_area: Node) -> void:
	animation_player.play("destroy")
