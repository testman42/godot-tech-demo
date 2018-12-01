extends Spatial

# SPHAGETTI: lol just spawn empty raycast with attached mesh that passes paramaters to actual hitscan
# TODO: find more elegant way to merge hitscan and "animation" to reduce unnecesary script duplication

export var damage = 50
export var hitscan_range = 100

func _ready():
	var hitscan_node = load("res://game/world/actors/mechanics/hitscan/hitscan_damage.tscn")
	var hitscan = hitscan_node.instance()
	hitscan.damage = damage
	hitscan.hitscan_range = hitscan_range
	hitscan.damage_type = "laser"
	hitscan.global_transform = self.global_transform
	get_node("/root/game/game_world/actors").add_child(hitscan)
	yield(get_tree().create_timer(0.1),"timeout")
	free()