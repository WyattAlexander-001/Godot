extends RigidBody2D

export var _asteroid_fragment_scene: PackedScene

onready var _collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
onready var _particles: Particles2D = $Particles2D
onready var _polygon: Polygon2D = $Polygon2D


## Split the asteroid polygon into smaller triangles and create
## AsteroidFragment instances.
func explode(origin: Vector2) -> void:
	var original_polygon = _polygon.polygon
	# Add an extra point to shatter at the point of impact. Adds destruction variation.
	original_polygon.append(origin)

	# Split the polygon into triangles using delaunay triangulation.
	# triangulate_delaunay_2d() returns a re-ordered list of indices (or
	# pointers) which can be used to get several triangles out of a polygon's
	# Vector2 points.
	var delaunay_pointers = Array(Geometry.triangulate_delaunay_2d(original_polygon))
	# Repeat for every group of three pointers.
	for pointer in range(0, delaunay_pointers.size(), 3):
		# Create a new triangle used for the fragment.
		var delaunay_triangle = PoolVector2Array()
		# Cycle through each of the three points that make up the triangle.
		for point in delaunay_pointers.slice(pointer, pointer + 2):
			# Add a Vector2 point from the original polygon to the new triangle.
			delaunay_triangle.append(original_polygon[point])
		# Create an asteroid fragment from the new triangle, using the same texture.
		var fragment = _asteroid_fragment_scene.instance()
		fragment.setup(delaunay_triangle, _polygon.texture)
		add_child(fragment)
	# Now the fragments spawned, we can hide or delete the original polygon.
	_polygon.visible = false
	_collision_polygon.disabled = true

	# Move the particle emitter to the point of impact.
	_particles.position = origin
	_particles.restart()


func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		explode(get_local_mouse_position())
