extends "res://game/world/actors/objects/weapons/weapon.gd"

var actions = []

func _ready():
	var action1 = load("res://game/world/actors/mechanics/hitscan/laser/laser.tscn")
	actions.append(action1)

func activate(fire_mode, event):
	if event == "pressed":
		fire()

func fire():
	var beam = actions[0].instance()
	beam.damage = 50
	beam.hitscan_range = 100
	beam.global_transform = $shoot_direction.global_transform
	get_node("/root/game/game_world/actors").add_child(beam)