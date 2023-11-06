extends Node2D

onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var area: Area2D = $Area2D


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	# We use duck-typing to ensure the colliding entity can take damage.
	if body.has_method("take_damage"):
		body.take_damage()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_anim_player.play("Attack")
