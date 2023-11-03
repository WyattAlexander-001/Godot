extends Area2D

export (float, 0.01, 1.0) var rotation_factor := 0.1

var target: PhysicsBody2D = null

onready var sprite := $Sprite
onready var timer := $Timer
onready var cannon := $Sprite/Position2D


func _ready() -> void:
	# We use the timer to control the rate of fire. By default, timers run
	# continuously and emit their timeout signal periodically.
	timer.connect("timeout", self, "_on_Timer_timeout")
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _physics_process(_delta: float) -> void:
	# We want a default target angle in case there's no target
	var target_angle := PI / 2.0
	if target:
		# If there's a target, we replace the default target angle by finding
		# the angle to the PhysicsBody2D.
		target_angle = target.global_position.angle_to_point(global_position)
	# Every frame, we rotate the sprite towards the target angle by the rotation
	# factor. If the rotation factor is 1.0, the sprite will instantly face the
	# target.
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)


func _on_body_entered(body: Node) -> void:
	target = body


func _on_body_exited(_body: Node) -> void:
	target = null


func _on_Timer_timeout() -> void:
	# We load the rockt scene and instantiate it.
	var rocket: Area2D = preload("common/Rocket.tscn").instance()
	add_child(rocket)
	# This line copies the `cannon`'s position, rotation, and scale at once,
	# placing and orienting the rocket properly.
	rocket.global_transform = cannon.global_transform
