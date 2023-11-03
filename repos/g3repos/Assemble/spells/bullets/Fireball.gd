extends Bullet

onready var _animation_player := $AnimationPlayer as AnimationPlayer
onready var _particles := $Particles2D as Particles2D


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	_animation_player.play("spawn")
	_audio.stream = preload("hit_fire.wav")


func _on_body_entered(body: Node) -> void:
	hit_body(body)
	_destroy()


func _destroy():
	set_physics_process(false)
	set_deferred("monitoring", false)
	_animation_player.play("destroy")
	_audio.pitch_scale = rand_range(0.9, 1.2)
	_audio.play()
