extends Area

var ui_text = "Press E to switch to RTS mode"

onready var main_loop = get_node("/root/game/game_logic/main_loop")
onready var player = get_node("/root/game/game_world/actors/characters/player")

func click(object):
	main_loop.switch_game_mode("rts")
	player.stop_control()