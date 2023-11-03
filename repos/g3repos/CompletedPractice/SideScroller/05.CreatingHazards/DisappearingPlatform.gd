extends StaticBody2D

onready var animation_player := $AnimationPlayer
onready var player_detector := $PlayerDetector

func _ready() -> void:
	player_detector.connect("body_entered", self, "_on_PlayerDetector_body_entered")

func _on_PlayerDetector_body_entered(body: Node) -> void:
	animation_player.play("fade")
