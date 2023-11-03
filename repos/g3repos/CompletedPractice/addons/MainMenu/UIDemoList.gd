# Finds all the scenes in a given directory and presents them as a list of
# selectable items.
#
# This class can filter visible items by search queries and general categories
# (2D, 3D, etc.).
#
# Emits a signal when the player select an item or presses it so another node
# can handle the loading and scene navigation.
class_name UIDemoList
extends ScrollContainer

# Emitted when the player double-clicks a demo
signal demo_requested
# Emitted after updating the visible items in the list, like when filtering them
# through a search.
signal display_updated(item_count)

const DemoItemScene := preload("UIDemoItem.tscn")
const DemoItem := preload("UIDemoItem.gd")
const SceneMetadata := preload("SceneMetadata.gd")

# List of directories to walk recursively to find tscn files.
export var demos_dirpaths := []
export var icons_dirpath := "res://addons/MainMenu/"
export var filenames_to_ignore := []

# Path to the selected demo's scene file.
var demo_path := ""
# Category filter applied to list items. See `_on_FilterButton_toggled()` for more information.
var category_filter: String setget set_category_filter

# Maps demo names as displayed in the list to paths to scenes to load.
var _demo_scenes := {}
var _items := []
var _selected_item: DemoItem = null
var _focused_item_index := 0

var _capital_letter_regex := RegEx.new()

onready var _container := $VBoxContainer
onready var _no_results := $NoResultsLabel


func _init() -> void:
	_capital_letter_regex.compile("[A-Z]")


func _ready() -> void:
	_no_results.hide()
	connect("focus_entered", self, "_scroll_to_item", ["select_first_item"])
	connect("visibility_changed", self, "_on_visibility_changed")

	select_first_item()


# Connects to filter buttons to set the `category_filter` upon clicking them.
func setup(filter_buttons: Array) -> void:
	for button in filter_buttons:
		button.connect("toggled", self, "_on_FilterButton_toggled", [button.text.to_lower()])


# Updates visible demo items based on the search query and the `category_filter`.
func update_display(search_filter := "") -> void:
	var visible_count := 0
	search_filter = search_filter.to_lower()
	for item in _items:
		if item.is_connected("focus_entered", self, "_scroll_to_item"):
			item.disconnect("focus_entered", self, "_scroll_to_item")
		# We need to check the search against every keyword corresponding to a node.
		# See nodes_metadata.json to add search terms for specific nodes.
		var search_terms := [item.demo_name]

		item.visible = true
		if search_filter:
			item.visible = false
			for term in search_terms:
				if search_filter.is_subsequence_of(term.to_lower()):
					item.visible = true
					break

		if item.visible:
			visible_count += 1
			item.connect("focus_entered", self, "_scroll_to_item", [item, visible_count - 1])
	_no_results.visible = visible_count == 0
	emit_signal("display_updated", visible_count)


func set_category_filter(value: String) -> void:
	category_filter = value
	update_display()


func select_first_item() -> void:
	scroll_vertical = 0
	for item in _items:
		if not item.visible:
			continue
		_select_item(item)
		return


# Returns a list of files found in a list of directories. Searches directories
# recursively.
func find_files_in_directories(directory_paths := []) -> Array:
	var demo_scene_paths := []
	for directory_path in directory_paths:
		demo_scene_paths.append_array(_find_files(directory_path, ["*.tscn"], true))
	return demo_scene_paths


# Creates buttons from the list of SceneMetadata objects.
func create_demo_buttons(scene_metadata := [], sort_by_name := true) -> void:
	if sort_by_name:
		scene_metadata.sort_custom(self, "_sort_demo_scenes")

	# Create a list entry for each demo and store the mapping of demo names to
	# file paths as a dictionary.
	var index := 0
	for entry in scene_metadata:
		_demo_scenes[entry.name] = entry.path

		var item := DemoItemScene.instance()
		_container.add_child(item)
		item.demo_name = entry.name
		
		_items.append(item)
		item.connect("pressed", self, "_select_item", [item])
		item.connect("focus_entered", self, "_scroll_to_item", [item, index])
		item.connect("demo_requested", self, "_request_demo", [item])
		index += 1

	_selected_item = _items[0]


func _request_demo(item: DemoItem) -> void:
	_select_item(item)
	emit_signal("demo_requested")


func _select_item(item: DemoItem) -> void:
	_selected_item = item
	item.grab_focus()
	demo_path = _demo_scenes[item.demo_name]


func _scroll_to_item(item: DemoItem, index: int) -> void:
	var direction := index - _focused_item_index
	if direction == 0:
		return

	if direction < 0 and item.rect_position.y < scroll_vertical:
		scroll_vertical = item.rect_position.y
	elif (
		direction > 0
		and item.rect_position.y > rect_size.y / 2 + rect_position.y + scroll_vertical
	):
		scroll_vertical = item.rect_position.y - rect_size.y + item.rect_size.y

	_focused_item_index = index


# Converts the demo name in PascalCase to a title to display.
func _pascal_case_to_title(demo_name: String) -> String:
	demo_name = demo_name.split(".", true, 1)[0]
	demo_name = _capital_letter_regex.sub(demo_name, " $0", true)
	return demo_name.strip_edges()


# Finds files that match a list of `patterns` in the directory `dirpath`.
# Each pattern is a string the function runs through Godot's `String.match()`: it supports wildcards and question marks.
func _find_files(
	dirpath := "",
	patterns := PoolStringArray(),
	is_recursive := false,
	do_skip_hidden := true,
	ignore_filenames := []
) -> PoolStringArray:
	var paths := PoolStringArray()
	var directory := Directory.new()

	if not directory.dir_exists(dirpath):
		printerr("The directory does not exist: %s" % dirpath)
		return paths
	if not directory.open(dirpath) == OK:
		printerr("Could not open the following dirpath: %s" % dirpath)
		return paths

	directory.list_dir_begin(true, do_skip_hidden)
	var file_name := directory.get_next()
	while file_name != "":
		if directory.current_is_dir() and is_recursive:
			var subdirectory := dirpath.plus_file(file_name)
			paths.append_array(
				_find_files(subdirectory, patterns, is_recursive, true, filenames_to_ignore)
			)
		elif file_name in ignore_filenames:
			pass
		else:
			for pattern in patterns:
				if file_name.match(pattern):
					paths.append(dirpath.plus_file(file_name))
		file_name = directory.get_next()

	directory.list_dir_end()
	return paths


# Used to sort the demos by name.
static func _sort_demo_scenes(a: SceneMetadata, b: SceneMetadata) -> bool:
	return a.name < b.name


func _on_FilterButton_toggled(button_pressed: bool, button_text: String) -> void:
	set_category_filter(button_text if button_pressed else "")


func _on_visibility_changed() -> void:
	if visible:
		_select_item(_selected_item)
