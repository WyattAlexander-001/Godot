# ANCHOR: extends
extends Area2D
# END: extends

# ANCHOR: ready_and_body_entered
onready var animation_player := $AnimationPlayer

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node) -> void:
	animation_player.play("destroy")
	apply_effect(body)
# END: ready_and_body_entered


# ANCHOR: apply_effect
# Virtual function. Applies this pickup's effect on the body node.
func apply_effect(body: Node) -> void:
	pass
# END: apply_effect
