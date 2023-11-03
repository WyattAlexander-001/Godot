extends Area2D

signal activated()


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node) -> void:
	emit_signal("activated", body)


func _on_body_exited(body: Node) -> void:
	emit_signal("activated", body)
