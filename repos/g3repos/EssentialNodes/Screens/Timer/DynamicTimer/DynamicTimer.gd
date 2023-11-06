extends Control

## A sequence of four animation names to play with our AnimationPlayer.
var light_sequence := [
	"stop",
	"ready",
	"go",
	"stop_soon"
]

onready var _animation_player := $AnimationPlayer


func animate_traffic_lights() -> void:
	# We loop over and play each animation from `light_sequence`.
	for animation in light_sequence:
		_animation_player.play(animation)
		# After each animation, we wait for a random duration between one
		# and two seconds.
		yield(get_tree().create_timer(rand_range(1.0, 2.0)), "timeout")
		# A precaution should the scene exit the scene tree after the timer 
		# completes. Trying to access the tree in this case will cause a crash.
		if not is_inside_tree():
			return
	animate_traffic_lights()

func _ready() -> void:
	randomize()
	animate_traffic_lights()


func _enter_tree() -> void:
	if _animation_player:
		_animation_player.stop(true)
		animate_traffic_lights()
