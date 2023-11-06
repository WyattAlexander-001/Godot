extends Node2D

onready var _spikes_visibility: VisibilityNotifier2D = $Spikes/SpikesVisibilityNotifier2D
onready var _ui_anim_player: AnimationPlayer = $UI/AnimationPlayer
onready var _player := $PlayerSideScroll
onready var _player_hurt_area: Area2D = $PlayerSideScroll/HurtArea2D

func _ready() -> void:
	_spikes_visibility.connect("screen_entered", _ui_anim_player, "play", ["pop_panel"])
	_spikes_visibility.connect("screen_exited", _ui_anim_player, "play", ["shrink_panel"])
	_player_hurt_area.connect("area_entered", self, "_on_player_area_entered")


func _on_player_area_entered(_area_in: Area2D) -> void:
	_player.queue_free()
