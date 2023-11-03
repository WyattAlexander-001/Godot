extends Control

var ITEMS := [
	{
		name = "Sword",
		texture = preload("items/sword.png"),
	},
	{
		name = "Fire Gem",
		texture = preload("items/gem_fire.png"),
	},
	{
		name = "Ice Gem",
		texture = preload("items/gem_ice.png"),
	},
	{
		name = "Lightning Gem",
		texture = preload("items/gem_lightning.png"),
	},
	{
		name = "Healing Gem",
		texture = preload("items/gem_health.png"),
	},
]


func get_random_item() -> Dictionary:
	# Return a random value from the ITEMS array instead of always the first one.
	return ITEMS[0]
