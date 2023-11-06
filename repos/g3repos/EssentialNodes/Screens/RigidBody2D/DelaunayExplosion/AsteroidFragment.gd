extends RigidBody2D

## Maximum force to shoot the fragment outward.
const MAX_FORCE := 666
## Minimum force to shoot the fragment outward.
const MIN_FORCE := 333

onready var _collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
onready var _polygon: Polygon2D = $Polygon2D


## Gives the fragment its shape and appearance, sets a random velocity and
## direction.
func setup(polygon: PoolVector2Array, texture: Texture) -> void:
	# We call function before adding this node to the scene tree.
	yield(self, "ready")
	randomize()
	_collision_polygon.polygon = polygon
	_polygon.polygon = polygon
	_polygon.texture = texture
	linear_velocity = (
		rand_range(MIN_FORCE, MAX_FORCE)
		* Vector2.UP.rotated(rand_range(0, TAU))
	)
