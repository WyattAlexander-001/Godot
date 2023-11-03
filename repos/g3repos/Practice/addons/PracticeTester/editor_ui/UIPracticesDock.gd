tool
extends Control

signal reset_progress_confirmed
signal practice_state_reset(practice_name)

const UIPracticeItemScene := preload("UIPracticeItem.tscn")

const UIPracticeItem := preload("UIPracticeItem.gd")
const UIResetButton := preload("UIResetButton.gd")

const RevealerScene := preload("CheckmarkRevealer.tscn")

# Path used by the UserProfile resource to pass a newly completed practice.
const COMPLETED_PATH := "user://new_completed_practices.cache"

var _editor_interface: EditorInterface
var _filesystem_dock: FileSystemDock

var _practice_name_to_item := {}

# We keep track of the last open practice revealer to fold it when opening a new
# one.
var _open_practice: UIPracticeItem = null setget _set_open_practice

# Used to read newly completed practices.
var _file := File.new()
var _directory := Directory.new()

var _practice_reverter := preload("PracticeReverter.gd").new()

var _practice_count := 0
var _total_completed_practices := 0

onready var _column := $Column/ScrollContainer/Column as VBoxContainer
onready var _reset_button := $Column/UIResetButton as UIResetButton
onready var _poll_timer := $PollTimer as Timer
onready var _success_label := $Column/SuccessLabel
onready var _progress_bar := $Column/PanelContainer/ProgressBar


func _ready() -> void:
	_reset_button.connect("reset_progress_confirmed", self, "_erase_progress")

	# May help prevent user progress getting wiped if running the practice scene
	# with Run in the project manager.
	if _file.file_exists(COMPLETED_PATH):
		_directory.remove(COMPLETED_PATH)


func setup(editor_interface: EditorInterface, course: Course) -> void:
	_poll_timer.connect("timeout", self, "_on_PollTimer_timeout")
	_editor_interface = editor_interface
	_filesystem_dock = _editor_interface.get_file_system_dock()

	var project_number := 1
	var practice_number := 1

	# Multiply sizes by editor scale.
	var editor_scale := _editor_interface.get_editor_scale()

	rect_min_size.x = 300 * editor_scale
	var base_font_size: int = _editor_interface.get_editor_settings().get_setting("interface/editor/main_font_size")
	var practice_subtitle_font_size := base_font_size + 1
	var practice_font_size := base_font_size + 2
	var chapter_font_size := base_font_size + 4

	var font_title_chapter := preload("font_title_chapter.tres").duplicate()
	var font_title_practice := preload("font_title_practice.tres").duplicate()
	var font_subtitle_practice := preload("font_subtitle_practice.tres").duplicate()
	var font_button := preload("font_button.tres").duplicate()
	var font_progress_bar := preload("font_progress_bar.tres").duplicate()

	font_title_chapter.size = chapter_font_size
	font_title_practice.size = practice_font_size
	font_subtitle_practice.size = practice_subtitle_font_size
	font_button.size = practice_font_size
	font_progress_bar.size = base_font_size - 2

	var font_text := preload("font_text.tres").duplicate()
	var font_bold := preload("font_text_bold.tres").duplicate()
	var font_italics := preload("font_text_italics.tres").duplicate()
	var font_bold_italics := preload("font_text_bold_italics.tres").duplicate()
	var font_mono := preload("font_code.tres").duplicate()

	for font in [font_mono, font_bold, font_italics, font_bold_italics, font_text]:
		font.size = base_font_size

	theme = theme.duplicate(true)
	var fonts := [
		theme.default_font,
		font_title_chapter,
		font_title_practice,
		font_subtitle_practice,
		font_button,
		font_progress_bar,
		font_text,
		font_bold,
		font_italics,
		font_bold_italics,
		font_mono,
	]
	for font in fonts:
		font.size *= editor_scale

	# Scale revealer panels with editor scale
	var panel_revealer_title := preload("../ui/theme/revealer_title_panel.tres").duplicate()
	panel_revealer_title.content_margin_left *= editor_scale
	panel_revealer_title.content_margin_right *= editor_scale
	panel_revealer_title.content_margin_top *= editor_scale
	panel_revealer_title.content_margin_bottom *= editor_scale

	var panel_revealer_content := preload("revealer_content_panel.tres").duplicate()
	panel_revealer_content.content_margin_left *= editor_scale
	panel_revealer_content.content_margin_right *= editor_scale
	panel_revealer_content.content_margin_top *= editor_scale
	panel_revealer_content.content_margin_bottom *= editor_scale

	var panel_practice_inner_content := preload("revealer_inner_content_panel.tres").duplicate()
	panel_practice_inner_content.content_margin_left *= editor_scale
	panel_practice_inner_content.content_margin_right *= editor_scale
	panel_practice_inner_content.content_margin_top *= editor_scale
	panel_practice_inner_content.content_margin_bottom *= editor_scale

	_reset_button.reset_button.add_font_override("font", font_button)
	_progress_bar.add_font_override("font", font_progress_bar)

	# Generate nested revealers for practices
	_practice_count = course.get_practice_count()
	for chapter in course.chapters:
		var chapter_revealer: CheckmarkRevealer = RevealerScene.instance()

		chapter_revealer.title_panel = panel_revealer_title
		chapter_revealer.title_panel_expanded = chapter_revealer.title_panel
		chapter_revealer.title_font = font_title_chapter
		chapter_revealer.content_panel = panel_revealer_content
		chapter_revealer.title = "%d. %s" % [project_number, chapter.title.capitalize()]

		practice_number = 1
		project_number += 1

		var completed_count := 0

		for practice in chapter.practices:
			var instance: UIPracticeItem = UIPracticeItemScene.instance()
			chapter_revealer.add_child(instance)
			instance.setup(practice, font_title_practice, font_text, font_bold, font_italics, font_bold_italics, font_mono, font_subtitle_practice, panel_practice_inner_content)
			instance.call_deferred("set_font_button", font_button)
			instance.connect("scene_open_requested", self, "_set_open_practice", [instance])
			instance.connect("scene_open_requested", self, "open_scene", [practice.path])
			instance.connect(
				"scene_revert_requested", self, "_revert_practice", [practice.title, practice.path]
			)
			_practice_name_to_item[practice.title] = instance
			practice_number += 1
			if practice.completed:
				_total_completed_practices += 1
				completed_count += 1

		_column.add_child(chapter_revealer)

		if completed_count == chapter.practices.size():
			chapter_revealer.mark_as_completed()

	update_progress_display()


func update_progress_display() -> void:
	_progress_bar.value = float(_total_completed_practices) / _practice_count


func open_scene(scene_path: String) -> void:
	_editor_interface.open_scene_from_path(scene_path)
	_filesystem_dock.navigate_to_path(scene_path)
	ProjectSettings.set_setting("application/run/main_scene", scene_path)
	ProjectSettings.save()


#TODO: rewrite to find the chapter node, then loop over children, and count completed marks?
func mark_as_completed(practice_name: String) -> void:
	if not _practice_name_to_item.has(practice_name):
		printerr(
			"Trying to update UIPracticeItem for practice '%s' but it was not found" % practice_name
		)
		return
	var instance: UIPracticeItem = _practice_name_to_item[practice_name]
	if instance.is_completed():
		return

	instance.mark_as_completed()
	_total_completed_practices += 1
	update_progress_display()

	var chapter_revealer: Revealer = instance.get_parent()
	var items := chapter_revealer.get_contents()
	var completed_count := 0
	for item in items:
		if item.is_completed():
			completed_count += 1

	if completed_count == items.size():
		chapter_revealer.mark_as_completed()


func _erase_progress() -> void:
	emit_signal("reset_progress_confirmed")
	for chapter_revealer in _column.get_children():
		chapter_revealer.remove_completed_mark()
		for item in chapter_revealer.get_contents():
			item.remove_completed_mark()
	_success_label.display("Progress reset successfully")
	_total_completed_practices = 0
	update_progress_display()


# Workaround impossibility to share a resource instance between the editor and
# the running game.
func _on_PollTimer_timeout() -> void:
	if _file.file_exists(COMPLETED_PATH):
		var error := _file.open(COMPLETED_PATH, File.READ)
		if error != OK:
			printerr("Could not open file '%s' to read newly completed practices." % COMPLETED_PATH)
			return

		var practice_names := _file.get_as_text().split("\n")
		for name in practice_names:
			if name.empty():
				break
			mark_as_completed(name)

		_file.close()
		var remove_error := _directory.remove(COMPLETED_PATH)
		if remove_error != OK:
			printerr(
				(
					"Could not delete file '%s' after consuming newly completed practices."
					% COMPLETED_PATH
				)
			)


func _revert_practice(practice_name: String, scene: String) -> void:
	var success := _practice_reverter.revert(scene)
	if success:
		_success_label.display("Practice reverted successfully")
		_total_completed_practices -= 1
	else:
		_success_label.display("Practice could not be reverted", false)
	emit_signal("practice_state_reset", practice_name)


func _set_open_practice(instance: UIPracticeItem) -> void:
	if instance == _open_practice:
		return

	if _open_practice != null:
		_open_practice.close()
	_open_practice = instance
