extends RigidBody

onready var _timer: Timer = $Timer

func _ready() -> void:
	connect("body_entered", self, "_on_Bullet_body_entered")
	_timer.connect("timeout", self, "queue_free")


func _on_Bullet_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()

