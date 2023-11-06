extends Node2D

onready var identifier := "Enemy %s" % get_tree().get_nodes_in_group("enemy").find(self)

onready var _visibility_notifier: VisibilityNotifier2D = $PathFollow2D/Sprite/VisibilityNotifier2D
onready var _label: Label = $LabelPivot/Label
onready var _anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_visibility_notifier.connect("screen_entered", self, "_on_VisibilityNotifier2D_screen_entered")
	_visibility_notifier.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	_label.text = identifier
	_anim_player.playback_speed = rand_range(0.5, 1.5)


func die() -> void:
	_anim_player.play("die")

func _on_VisibilityNotifier2D_screen_entered() -> void:
	add_to_group("visible")


func _on_VisibilityNotifier2D_screen_exited() -> void:
	remove_from_group("visible")
