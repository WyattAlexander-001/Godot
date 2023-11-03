extends Area2D

export var speed := 350.0
export var damage := 10.0

onready var timer := $Timer


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	timer.connect("timeout", self, "explode")


func _physics_process(delta: float) -> void:
	# The transform.x holds the direction in which the rocket is facing. We
	# multiply that direction by `speed` to calculate the rocket's velocity.
	position += transform.x * speed * delta


func explode() -> void:
	# We load the explosion scene and instantiate it.
	var explosion := preload("Explosion.tscn").instance()
	# Then, we place the explosion where the rocket is.
	explosion.global_position = global_position
	# We append the explosion to the main scene's children.
	get_tree().root.add_child(explosion)
	# And delete the rocket itself.
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	explode()
