extends Area2D

export(float, 0.01, 1.0) var rotation_factor := 0.1

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
	var target_angle := PI / 2
	if target:
		target_angle = target.global_position.angle_to_point(global_position)
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)

func _on_body_entered(body: Node) -> void:
	# We add the body to our target list.
	target_list.append(body)
	# We update the target variable to target the first element in the
	# target_list array.
	#
	# Since we just appended the body to the array, we know that there's at
	# least one target in the list, so we can safely get the array's first
	# item.
	target = target_list[0]

func _on_body_exited(body: Node) -> void:
	var index := target_list.find(body)
	target_list.remove(index)
	if target_list:
		# The body that left the area may be the current target, which is why we
		# must update the target if the array isn't empty.
		target = target_list[0]
	else:
		target = null

func _on_Timer_timeout() -> void:
	# If there are no targets in the target_list array, we stop the function and
	# skip firing a rocket.
	if not target_list:
		return
	var rocket := preload("common/Rocket.tscn").instance()
	add_child(rocket)
	rocket.global_transform = cannon.global_transform
