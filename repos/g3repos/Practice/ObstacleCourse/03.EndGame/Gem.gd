extends Area2D


func _ready() -> void:
	# Connect the gem's signal to _on_body_entered() and call queue_free()
	# from the callback function to destroy the gem.
	pass


func _on_body_entered(body: Node) -> void:
	pass
