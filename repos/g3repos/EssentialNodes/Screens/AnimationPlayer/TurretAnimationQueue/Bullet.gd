extends Node2D

const SPEED := 1000.0

var direction := Vector2.ZERO

onready var _sprite := $Sprite
onready var _particles := $Particles2D
onready var _timer := $Timer


func _ready() -> void:
	set_as_toplevel(true)


func _process(delta: float) -> void:
	position += direction * delta * SPEED


func _on_Timer_timeout() -> void:
	queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	if not body is Player or not _sprite.visible:
		return

	body.take_damage()
	set_process(false)
	_sprite.visible = false
	_particles.restart()
	_timer.start(1.0)
