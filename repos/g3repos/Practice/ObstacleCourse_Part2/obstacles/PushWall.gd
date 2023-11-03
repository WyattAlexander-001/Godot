extends Node2D


# ANCHOR: onready
onready var area: Area2D = $Area2D
onready var animation_player: AnimationPlayer = $AnimationPlayer
# END: onready


# ANCHOR: functions
func _ready() -> void:
	area.connect("body_entered", self, "_on_Area2D_body_entered")


func _on_Area2D_body_entered(body: Node) -> void:
	animation_player.play("push_down")
# END: functions
