extends Control

onready var panels := $MarginContainer/VBoxContainer/Panel/ScrollContainer/MarginContainer/Panels


func _draw() -> void:
	for panel in panels.get_children():
		if not panel.active:
			continue
		# Draw the line from the panel to the target
		var target_position = panel.target_node.global_position
		var panel_position = panel.get_global_transform().get_origin()
		panel_position.y += panel.rect_size.y/2
		panel_position.x += 5
		# Line ends at the edge of the circle surrounding the object
		var direction = target_position.direction_to(panel_position)
		var radius = panel.target_node.get_rect().size * panel.target_node.scale.x / 2
		draw_line(target_position + direction * radius, panel_position, Color("#586ac8"), 5)


func _process(delta: float) -> void:
	update()
