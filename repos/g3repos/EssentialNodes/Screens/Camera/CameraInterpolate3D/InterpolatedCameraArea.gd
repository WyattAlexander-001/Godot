extends Area

onready var _position: Position3D = $Position3D


func _ready() -> void:
	connect("body_entered", self, "_on_Area_body_entered")
	connect("body_exited", self, "_on_Area_body_exited")


func _on_Area_body_entered(body: PhysicsBody) -> void:
	if body.has_method("change_camera_focus"):
		body.change_camera_focus(_position.global_transform)


func _on_Area_body_exited(body: PhysicsBody) -> void:
	if body.has_method("reset_camera_focus"):
		body.reset_camera_focus()
