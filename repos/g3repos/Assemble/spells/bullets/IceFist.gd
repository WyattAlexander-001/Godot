extends Bullet

onready var _sprite := $Sprite
onready var _particles := $Particles2D


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	_audio.stream = preload("hit_ice.wav")


func _on_body_entered(body: Node) -> void:
	hit_body(body)

	_audio.pitch_scale = rand_range(0.9, 1.2)
	_audio.play()

	_sprite.hide()
	_particles.emitting = true
	speed = 0.0

	yield(_audio, "finished")
	queue_free()
