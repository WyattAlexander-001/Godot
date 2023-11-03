## Changes the player's current weapon randomly from a list of all cannons.
extends Pickup

const ICONS_MAP := {
	preload("res://spells/FireSpray.tscn"): preload("pickup_fire.png"),
	preload("res://spells/RapidFire.tscn"): preload("pickup_fire.png"),
	preload("res://spells/IcePunch.tscn"): preload("pickup_ice.png"),
	preload("res://spells/LightningShot.tscn"): preload("pickup_lightning.png"),
}

const SOUNDS_MAP := {
	preload("res://spells/FireSpray.tscn"): preload("pickup_fire.wav"),
	preload("res://spells/RapidFire.tscn"): preload("pickup_fire.wav"),
	preload("res://spells/IcePunch.tscn"): preload("pickup_ice.wav"),
	preload("res://spells/LightningShot.tscn"): preload("pickup_lightning.wav"),
}

var _weapon_scene: PackedScene

onready var _sprite := $Sprite as Sprite


func _ready() -> void:
	var randomized_weapons: Array = GlobalResources.weapons.duplicate()
	randomized_weapons.shuffle()
	_weapon_scene = randomized_weapons.pop_back()
	_sprite.texture = ICONS_MAP[_weapon_scene]
	_audio.stream = SOUNDS_MAP[_weapon_scene]

func _pickup(player: Player) -> void:
	player.add_weapon(_weapon_scene)
