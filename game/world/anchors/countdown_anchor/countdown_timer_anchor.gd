extends "res://game/world/anchors/anchor.gd"

func _ready():
	UI_element_path = "res://game/user_interface/UI_elements/status_indicators/countdown_indicator/countdown_indicator.tscn"
	spawn()
	
#	add_to_group("UI_anchors")
#	var UI_element_scene = load(UI_element_path)
#	var UI_element = UI_element_scene.instance()
#	UI_element.add_to_group("UI_elements")
#	add_child(UI_element)