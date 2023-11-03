extends Node2D


onready var area := $Area2D
onready var animation_player := $AnimationPlayer


func _ready() -> void:
	# This signal emits when a physics body, like the player, enters the area.
	area.connect("body_entered", self, "_on_Area2D_body_entered")


# The Area2D.body_entered signal always emits along with an argument, the
# physics body that entered the area. That's why we must include an argument in
# this callback function.
func _on_Area2D_body_entered(body: Node) -> void:
	animation_player.play("push_down")

