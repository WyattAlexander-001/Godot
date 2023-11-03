extends Panel

var speed := 500

onready var player := $Player

func _physics_process(_delta):
	var velocity := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.normalized() * speed
	player.move_and_slide(velocity)
