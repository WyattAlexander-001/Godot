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
	check_Inputs()


func check_Inputs():
	if Input.is_action_pressed("ui_left"):
		rotate_y(deg_to_rad(-SPEED))
		print(minion() + " LEFT")
	elif Input.is_action_pressed("ui_right"):
		rotate_y(deg_to_rad(SPEED))	
		print(minion() + " RIGHT")
		
#	rotate_y(0.1)
#	rotate_z(deg_to_rad(SPEED)
func minion():
	return "I'm a minion! Hello WORLD!"
