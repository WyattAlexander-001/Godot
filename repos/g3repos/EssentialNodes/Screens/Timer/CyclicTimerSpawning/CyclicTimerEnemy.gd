extends Node2D

var player_reference: Node2D


func _process(delta: float) -> void:
	if not player_reference:
		return

	look_at(player_reference.global_position)
	if not $AnimationPlayer.is_playing():
		global_position = lerp(global_position, player_reference.global_position, delta)


func _on_Area2D_body_entered(body: Node) -> void:
	set_process(false)
	if body is Player:
		$AnimationPlayer.play("die")
