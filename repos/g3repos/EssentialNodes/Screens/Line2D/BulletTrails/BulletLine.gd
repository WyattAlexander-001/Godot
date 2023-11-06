extends Node2D
const SPEED := 2500.0

var direction := Vector2.ZERO

onready var _particles := $Particles2D
onready var _timer := $Timer


func _ready() -> void:
	set_as_toplevel(true)


func _process(delta: float) -> void:
	position += direction * delta * SPEED


func _on_Timer_timeout() -> void:
	queue_free()


func _on_Area2D_body_entered(_body: Node) -> void:
	set_process(false)
	_particles.restart()
	_timer.start(1.0)
