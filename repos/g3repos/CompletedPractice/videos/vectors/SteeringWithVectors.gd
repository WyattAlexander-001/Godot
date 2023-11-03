extends Node2D

onready var ship := $SteeringShipCopy

onready var steering: Vector2D = $Pivot/Steering
onready var desired: Vector2D = $Pivot/Desired
onready var velocity: Vector2D = $Pivot/Velocity

onready var pivot := $Pivot

func _process(delta: float) -> void:
	pivot.position = ship.position

	velocity.vector = ship.velocity / 2
	desired.vector = ship.desired_velocity / 2
	steering.vector = ship.steering_vector / 2
	steering.position = velocity.vector
