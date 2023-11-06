extends Area2D


onready var _sprite: Sprite = $Sprite


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	_sprite.modulate.a -= delta
	_sprite.scale *= (1.0 + delta)
	if _sprite.modulate.a <= 0.0:
		queue_free()


func _on_body_entered(_body: Node) -> void:
	set_physics_process(true)
