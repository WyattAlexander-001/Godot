extends Area

const SPEED := 12.5
var direction := Vector3.ZERO
onready var _animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")


func _physics_process(delta: float) -> void:
	translate(direction * delta * SPEED)


func on_body_entered(body: Node) -> void:
	if body == get_parent():
		return
	_animator.stop()
	_animator.play("Collide")
	if body.has_method("take_damage"):
		body.take_damage()
