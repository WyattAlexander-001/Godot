extends Panel

onready var vbox_container: VBoxContainer = $VBoxContainer


func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var visibility: VisibilityNotifier2D = enemy.find_node("VisibilityNotifier2D")
		visibility.connect(
			"screen_entered", self, "_on_VisibilityNotifier2D_screen_entered", [enemy.identifier]
		)

		visibility.connect(
			"screen_exited", self, "_on_VisibilityNotifier2D_screen_exited", [enemy.identifier]
		)


func _on_VisibilityNotifier2D_screen_entered(enemy_identifier: String) -> void:
	var label := Label.new()
	label.text = enemy_identifier
	vbox_container.add_child(label)


func _on_VisibilityNotifier2D_screen_exited(enemy_identifier: String) -> void:
	for label in vbox_container.get_children():
		if label.text == enemy_identifier:
			label.queue_free()
