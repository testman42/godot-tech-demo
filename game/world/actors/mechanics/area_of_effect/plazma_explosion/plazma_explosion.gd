extends "res://game/world/actors/mechanics/area_of_effect/area_of_effect.gd"


func _ready():
	duration_time = 0.5
	is_player_attack = true
	effects["damage"] = [150, "explosion"] #damage amount, damage type
	start_timers()