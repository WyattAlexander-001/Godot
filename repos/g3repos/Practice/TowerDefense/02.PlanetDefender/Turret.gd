extends Area2D

signal rocket_spawned(rocket_node)

const Rocket := preload("../common/Rocket.gd")

var rotation_factor := 0.4

onready var sprite := $Sprite
onready var timer := $Timer
onready var cannon := $Sprite/Position2D

var targets := []
var target: PhysicsBody2D = null
var target_angle := 0.0


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	timer.connect("timeout", self, "_on_Timer_timeout")


func add_child(node: Node, legible_unique_name := false) -> void:
	.add_child(node, legible_unique_name)
	if node is Rocket:
		emit_signal("rocket_spawned", node)


func _physics_process(_delta: float) -> void:
	target_angle = PI / 2
	if target:
		# Make the turret find the angle to the mob here.
		pass
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)


func _on_body_entered(body: Node) -> void:
	targets.append(body)
	select_target()


func _on_body_exited(body: Node) -> void:
	var idx := targets.find(body)
	targets.remove(idx)
	select_target()


func select_target() -> void:
	if targets:
		target = targets[0]
	else:
		target = null

func _on_Timer_timeout() -> void:
	if not targets:
		return
	var rocket := preload("../common/Rocket.tscn").instance()
	add_child(rocket)
	# Make sure the rocket is aligned with the cannon.
	pass
