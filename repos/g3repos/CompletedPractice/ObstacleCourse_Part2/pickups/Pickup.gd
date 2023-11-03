extends Area2D

onready var animation_player := $AnimationPlayer

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node) -> void:
	animation_player.play("destroy")
	apply_effect(body)


# Virtual function. Applies this pickup's effect on the body node.
func apply_effect(body: Node) -> void:
	pass
