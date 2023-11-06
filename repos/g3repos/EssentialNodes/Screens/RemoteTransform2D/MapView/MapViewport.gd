tool
extends Viewport

const PLAYER_TEXTURE := preload("res://common/Player/player.png")
const ICON_TEXTURE := preload("res://common/crosshair.png")

# Path to the camera the map should follow.
export var world_camera_path: NodePath
# The zoom level we use for the map's camera. The larger the value, the more it zooms out and the more of the map appears.
export var zoom_factor := 8.0

func _ready() -> void:
	if Engine.editor_hint:
		return
	# To ensure the camera's available, we wait for the owner of this scene to be ready.
	# We could also use get_tree().root to wait for the camera, regardless of its position in the tree.
	yield(owner, "ready")
	# We wait for the owner node to be ready to ensure the camera is part of the scene tree.
	var world_camera: Camera2D = get_node(world_camera_path)
	# We then add a camera for the map view that follows the main camera, and populate the map with icons.
	add_camera_proxy(world_camera)
	populate_map()


func _get_configuration_warning() -> String:
	var warning := ""
	if not get_node_or_null(world_camera_path) is Camera2D:
		warning = "You must set a path to a Camera2D to follow in the map view."
	return warning


## Adds a camera to the map's viewport that follows the `world_camera`.
func add_camera_proxy(world_camera: Camera2D) -> void:
	var camera := Camera2D.new()
	add_child(camera)
	camera.current = true
	# To view far away on the map, we change its camera's zoom. You can let the player control this zoom to view more or less of the map.
	camera.zoom = zoom_factor * Vector2.ONE

	# We create a `RemoteTransform2D` and inject it as a child of the game world's camera, to synchronize our map's camera with it.
	var remote_transform := RemoteTransform2D.new()
	world_camera.add_child(remote_transform)
	remote_transform.remote_path = camera.get_path()

## Creates an icon on the map for every node in the `map` group.
func populate_map() -> void:
	var nodes_to_track := get_tree().get_nodes_in_group("map")
	for node in nodes_to_track:
		add_icon_to_map(node)


## Adds a sprite to the map that represents and tracks an entity in the game world.
func add_icon_to_map(node_to_track: Node2D) -> void:
	var sprite := Sprite.new()
	
	sprite.texture = PLAYER_TEXTURE if node_to_track is Player else ICON_TEXTURE
	add_child(sprite)
	# Scaling the sprite by our camera's zoom factor makes it preserve its size on the screen. Otherwise, it'll be small and aliased.
	sprite.scale = zoom_factor * Vector2.ONE

	# Here is where we inject a `RemoteTransform2D` as a child of the world's entity.
	var remote_transform := RemoteTransform2D.new()
	# We want to control the icon's scale ourselves so we set the remote transform not to push its parent's scale to the sprite.
	remote_transform.update_scale = false
	node_to_track.add_child(remote_transform)
	remote_transform.remote_path = sprite.get_path()
	# When the node in the world is freed, the `RemoteTransform2D` will be freed too.
	# The following line will let you destroy the paired icon as well.
	remote_transform.connect("tree_exited", sprite, "queue_free")
