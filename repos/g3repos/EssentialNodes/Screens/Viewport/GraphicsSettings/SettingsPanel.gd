extends PanelContainer

enum ShadowFilter { DISABLED, PCF5, PCF13 }

# Maps slider values to ShadowFilter settings
const SHADOW_SLIDER = {
	0 : ShadowFilter.DISABLED,
	1 : ShadowFilter.DISABLED,
	2 : ShadowFilter.PCF5,
	3 : ShadowFilter.PCF13
}
const SUPPORTED_RESOLUTIONS := [
	Vector2(1920, 1080),
	Vector2(1366, 768),
	Vector2(1280, 720),
	Vector2(960, 540),
]
const SHADOW_FILTER_SETTING := "rendering/quality/shadows/filter_mode"
const DEFAULT_SHADOW_ATLAS_SIZE := 1024

export var target_viewport := NodePath()

onready var _viewport: Viewport = get_node(target_viewport)

onready var _resolution: OptionButton = $VBoxContainer/Resolution/OptionButton
onready var _shadow_quality: Slider = $VBoxContainer/ShadowQuality/Slider
onready var _MSAA: OptionButton = $VBoxContainer/MSAA/OptionButton
onready var _FXAA: CheckBox = $VBoxContainer/FXAA/CheckBox


func _ready():
	_populate_resolutions()
	
	_resolution.connect("item_selected", self, "set_resolution")
	_shadow_quality.connect("value_changed", self, "set_shadow_quality")
	_MSAA.connect("item_selected", self, "set_msaa")
	_FXAA.connect("toggled", self, "set_fxaa")

## Fills the resolution drop-down menu with supported resolutions.
func _populate_resolutions() -> void:
	for index in SUPPORTED_RESOLUTIONS.size():
		var resolution: Vector2 = SUPPORTED_RESOLUTIONS[index]
		var resolution_as_string := "{x}x{y}".format({x = resolution.x, y = resolution.y})
		_resolution.add_item(resolution_as_string, index)

func set_shadow_quality(value: int):
	assert(
		value < SHADOW_SLIDER.size(),
		"Trying to set shadow filtering to an unmappped value."
	)
	# enable space for the shadows, otherwise don't give them space to render
	_viewport.shadow_atlas_size = DEFAULT_SHADOW_ATLAS_SIZE if value != 0 else 0
	# The Project-wide shadow filtering is the main visual change in this slider
	ProjectSettings.set(SHADOW_FILTER_SETTING, SHADOW_SLIDER[value])

func set_fxaa(value: bool) -> void:
	_viewport.fxaa = value

func set_msaa(level: int) -> void:
	_viewport.msaa = level

func set_resolution(index: int) -> void:
	assert(
		index < SUPPORTED_RESOLUTIONS.size(),
		"Trying to set the viewport to an unsupported resolution."
	)
	_viewport.size = SUPPORTED_RESOLUTIONS[index]

func reset_to_default_settings() -> void:
	_shadow_quality.value = ShadowFilter.PCF13
	_FXAA.pressed = false
	_resolution.select(0)
	set_resolution(0)
	_MSAA.select(0)
	set_msaa(0)
