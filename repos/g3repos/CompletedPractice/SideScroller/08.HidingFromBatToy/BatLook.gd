extends Sprite

var bat_textures := [
	preload("bat_aware.png"),
	preload("bat_hang.png")
]

onready var look_direction := $LookDirection
onready var raycast := $RayCast2D

func _physics_process(delta: float) -> void:
	# Rotate the raycast to look at the mouse cursor
	raycast.look_at(get_global_mouse_position())
	raycast.force_raycast_update()
	# We check if the ray collides with a KinematicBody2D. As the only
	# KinematicBody2D we can hit is the player, we update the bat's texture to
	# the mean-looking sprite.
	#
	# The is keyword checks for the type of the collider we get with
	# get_collider()
	if raycast.get_collider() is KinematicBody2D:
		texture = bat_textures[0]
	else:
		texture = bat_textures[1]
	# Visualizes the RayCast2D.
	look_direction.vector = to_local(raycast.get_collision_point())
