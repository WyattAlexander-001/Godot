extends StaticBody3D

# Example variable to control rotation speed.
@export var rotation_speed = 1.0
@onready var player = $"."
func _ready():
	# Assuming you want to start rotating immediately upon readiness.
	pass

func _process(delta):
	player.rotate_x(rotation_speed * delta)

