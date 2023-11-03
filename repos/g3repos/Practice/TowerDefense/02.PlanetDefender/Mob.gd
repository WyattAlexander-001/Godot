extends KinematicBody2D

var speed := 300
var velocity := Vector2()


func _physics_process(_delta: float) -> void:
	move_and_slide(velocity)
	rotation += 0.01


func take_damage(_damage: int) -> void:
	var explosion := preload("../common/Explosion.tscn").instance()
	get_tree().root.add_child(explosion)
	explosion.global_position = global_position
	queue_free()
