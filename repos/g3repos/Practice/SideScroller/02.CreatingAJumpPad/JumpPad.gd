extends StaticBody2D

onready var animation_player := $AnimationPlayer
onready var player_detector := $PlayerDetector

export var jump_increase_amount := 1500


func _ready() -> void:
	player_detector.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node):
	# The body is the robot here so you can access the robot's velocity by writing body.velocity, for example.
	# Make sure the robot is propelled by jump_increase_amount.
	pass
