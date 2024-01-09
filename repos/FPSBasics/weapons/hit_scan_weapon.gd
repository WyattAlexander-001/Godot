extends Node3D

@export var fire_rate := 14.0
@onready var cool_down_timer = $CoolDownTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("fire"):
		if cool_down_timer.is_stopped():
			cool_down_timer.start(1.0/fire_rate)
			print("weapon fired")
