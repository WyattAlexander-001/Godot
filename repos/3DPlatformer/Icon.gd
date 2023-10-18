extends Sprite3D

var coins = 5
var player_name = "robot"
var hearts = 3.5
const SPEED = 2


# Called when the node enters the scene tree for the first time.
func _ready():
#	pass # Replace with function body.
	print("Hello World")


# Called every frame. 'delta' is the elapsed time since the previous frame. 60fps
func _process(delta):
	rotate_y(0.1)
#	rotate_z(0.1)
