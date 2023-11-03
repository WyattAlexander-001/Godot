tool
extends Control

signal scene_open_requested
# Emitted when the user presses the revert button.
signal scene_revert_requested

# We keep the practice around for when we change the window width, we need to
# change the bbcode images' width.
var _practice: Practice
var _has_images := false

onready var _revealer := $Revealer as Revealer
onready var _column := $Revealer/Column
onready var _description := _column.get_node("Description") as RichTextLabel
onready var _tasks_list := _column.get_node("TasksList") as VBoxContainer
onready var _hints_list := _column.get_node("HintsList") as VBoxContainer
onready var _practiced_techniques := _column.get_node("PracticedTechniques") as Label
onready var _tasks_title := _column.get_node("TasksTitle") as Label
onready var _hints_title := _column.get_node("HintsTitle") as Label
onready var _hints_separator := _column.get_node("HSeparator2") as HSeparator

onready var _revert_button := _column.get_node("RevertButton") as Button


onready var _confirm_dialog := $ConfirmationDialog


func _ready() -> void:
	_confirm_dialog.set_as_toplevel(true)

	_revealer.connect("expanded", self, "emit_signal", ["scene_open_requested"])
	_revert_button.connect("pressed", _confirm_dialog, "popup_centered")
	_confirm_dialog.connect("confirmed", self, "emit_signal", ["scene_revert_requested"])
	_confirm_dialog.connect("confirmed", self, "remove_completed_mark")


func setup(
	practice: Practice,
	font_title: DynamicFont,
	font_text: DynamicFont,
	font_bold: DynamicFont,
	font_italics: DynamicFont,
	font_bold_italics: DynamicFont,
	font_mono: DynamicFont,
	font_subtitle: DynamicFont,
	panel_practice_inner_content: StyleBox
) -> void:

	if not is_inside_tree():
		yield(self, "ready")

	_practice = practice

	_revealer.title = practice.title
	_revealer.content_panel = panel_practice_inner_content
	_column.add_constant_override("separation", panel_practice_inner_content.content_margin_left)
	_revealer.connect("expanded", self, "_on_Revealer_expanded")

	_description.bbcode_text = practice.description
	_has_images = "[img" in practice.description

	_confirm_dialog.dialog_text = _confirm_dialog.dialog_text % [practice.title]

	_revealer.title_font = font_title
	_practiced_techniques.add_font_override("font", font_text)
	_description.add_font_override("normal_font", font_text)
	_description.add_font_override("bold_font", font_bold)
	_description.add_font_override("bold_italics_font", font_bold_italics)
	_description.add_font_override("italics_font", font_italics)
	_description.add_font_override("mono_font", font_mono)

	_tasks_title.add_font_override("font", font_subtitle)
	_hints_title.add_font_override("font", font_subtitle)

	for task in practice.tasks:
		var instance: UITaskItem = preload("UITaskItem.tscn").instance()
		_tasks_list.add_child(instance)
		instance.rich_text_label.bbcode_text = task.strip_edges()
		instance.rich_text_label.add_font_override("normal_font", font_text)
		instance.rich_text_label.add_font_override("bold_font", font_bold)
		instance.rich_text_label.add_font_override("bold_italics_font", font_bold_italics)
		instance.rich_text_label.add_font_override("italics_font", font_italics)
		instance.rich_text_label.add_font_override("mono_font", font_mono)

	_hints_title.visible = practice.hints.size() > 0
	_hints_separator.visible = _hints_title.visible
	_hints_list.visible = _hints_title.visible
	for i in practice.hints.size():
		var text: String = practice.hints[i].strip_edges()
		if not text:
			continue

		var instance: UIPracticeHint = preload("UIPracticeHint.tscn").instance()
		instance.title = "Hint " + str(i + 1)
		_hints_list.add_child(instance)
		instance.content_panel = panel_practice_inner_content
		instance.rich_text_label.bbcode_text = text.strip_edges()
		instance.rich_text_label.add_font_override("normal_font", font_text)
		instance.rich_text_label.add_font_override("bold_font", font_bold)
		instance.rich_text_label.add_font_override("bold_italics_font", font_bold_italics)
		instance.rich_text_label.add_font_override("italics_font", font_italics)
		instance.rich_text_label.add_font_override("mono_font", font_mono)

	_practiced_techniques.text = "Techniques: " + practice.techniques

	if practice.completed:
		mark_as_completed()

	_revealer.queue_sort()


func mark_as_completed() -> void:
	_revealer.mark_as_completed()


func remove_completed_mark() -> void:
	_revealer.remove_completed_mark()


func is_completed() -> bool:
	return _revealer.is_completed()


func close() -> void:
	_revealer.is_expanded = false
	if _has_images:
		disconnect("resized", self, "_update_description_images_width")


func set_font_button(new_font: DynamicFont) -> void:
	_revert_button.add_font_override("font", new_font)


func _on_Revealer_expanded() -> void:
	if _has_images:
		connect("resized", self, "_update_description_images_width")


func _update_description_images_width() -> void:
	var width_string := "[img=%s]" % str(floor(rect_size.x))
	_description.bbcode_text = _practice.description.replace("[img=$SIZE]", width_string)
