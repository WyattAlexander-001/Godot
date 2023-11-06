extends Node2D

## The maximum number of elements you can place on the map.
const MAX_BUILT_COUNT := 60

export (Array, Texture) var items := []

onready var _environment: Node2D = $Environment
onready var _build_preview: Sprite = $BuildPreview
onready var _build_button: Button = find_node("BuildModeButton")


func _ready() -> void:
	randomize_item_to_build()
	_build_preview.visible = false
	_build_button.connect("toggled", self, "set_preview_visibility")


func _process(delta: float) -> void:
	# Every frame, we place the ghost under the mouse cursor.
	_build_preview.position = get_local_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if _build_preview.visible and event.is_action_pressed("click"):
		randomize_item_to_build()
		var item = Sprite.new()
		item.texture = _build_preview.texture
		# When playing full demos, as we have multiple screens placed next to
		# one another, we need to offset the sprite's position.
		item.position = _build_preview.position

		_environment.add_child(item)
		if _environment.get_child_count() > MAX_BUILT_COUNT:
			_environment.remove_child(_environment.get_child(0))


# We assign a random item to this node to display a ghost of the element the
# player will build.
func randomize_item_to_build() -> void:
	items.shuffle()
	_build_preview.texture = items.front()


func set_preview_visibility(visibility: bool) -> void:
	_build_preview.visible = visibility
