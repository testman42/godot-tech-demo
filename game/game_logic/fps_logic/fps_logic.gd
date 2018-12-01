extends Node

onready var player = get_node("/root/game/game_world/actors/characters/player")

var can_toggle_camera = true

func update_select_bar():
	var selector_bar = get_node("/root/game/game_world/actors/characters/player/camera_anchor/first_person_camera/fps_preset/selector_bar")
	for category in player.inventory:
		for item in player.inventory[category]:
			selector_bar.show_item(item.name)
			#selector_bar.add_item_to_group(item.name, category)

# TODO: should this be handling the hit-marker size?
# TODO: find a way so that we don't look for crosshair node very time this gets called
func display_hit_marker(damage_amount):
	var crosshair = get_node("/root/game/game_world/actors/characters/player/camera_anchor/first_person_camera/fps_preset/crosshair")
	if damage_amount >= 50:
		crosshair.show_hit_marker(true)
	else:
		crosshair.show_hit_marker()

func write_to_event_log(string):
	var event_log = get_node("/root/game/game_world/actors/characters/player/camera_anchor/first_person_camera/fps_preset/event_log")
	event_log.write_line(string)
