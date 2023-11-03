extends Area2D

# Allow rotation factor to be changed from the editor
export(float, 0.01, 1) var rotation_factor := 0.4

var target: PhysicsBody2D = null
var target_list := []

onready var sprite := $Sprite
onready var timer := $Timer
onready var cannon := $Sprite/Position2D


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	timer.connect("timeout", self, "_on_Timer_timeout")


func _physics_process(_delta: float) -> void:
	_rotate_to_target()


func _rotate_to_target() -> void:
	var target_angle := PI / 2
	if target:
		target_angle = target.global_position.angle_to_point(global_position)
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)


func select_target() -> void:
	if target_list:
		target = target_list[0]
	else:
		target = null


func _on_body_entered(body: Node) -> void:
	target_list.append(body)
	select_target()


func _on_body_exited(body: Node) -> void:
	var index := target_list.find(body)
	target_list.remove(index)
	select_target()


# shoot a rocket every time the timer goes off
func _on_Timer_timeout() -> void:
	if not target_list:
		return
	var rocket := preload("common/Rocket.tscn").instance()
	add_child(rocket)
	rocket.global_transform = cannon.global_transform
