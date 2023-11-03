extends Area2D

onready var anim_player := $AnimationPlayer


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(_body: Node) -> void:
	anim_player.play("chest_open")


func _on_body_exited(_body: Node) -> void:
	anim_player.play_backwards("chest_open")
