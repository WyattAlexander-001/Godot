extends Area2D

var rotation_factor := 0.01

onready var sprite := $Sprite
onready var timer := $Timer
onready var cannon := $Sprite/Position2D

var target: PhysicsBody2D = null

var targets := []


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.wait_time = 0.3


func _physics_process(_delta: float) -> void:
	var target_angle := PI / 2
	if target:
		target_angle = target.global_position.angle_to_point(global_position)
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)


func select_target() -> void:
	if targets:
		target = targets[0]
	else:
		target = null


func _on_body_entered(body: Node) -> void:
	targets.append(body)
	select_target()


func _on_body_exited(body: Node) -> void:
	var idx := targets.find(body)
	targets.remove(idx)
	select_target()


func _on_Timer_timeout() -> void:
	if not targets:
		return
	var rocket := preload("Rocket.tscn").instance()
	add_child(rocket)
	rocket.global_transform = cannon.global_transform
