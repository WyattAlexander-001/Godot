extends Area2D

onready var animation_player := $AnimationPlayer

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node) -> void:
	body.take_damage(1)
	animation_player.play("was_hit")
