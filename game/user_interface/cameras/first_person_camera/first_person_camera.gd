extends "res://game/user_interface/cameras/camera.gd"

# TODO: figure out if you even need UI layer since it appears that 3D nodes displaying their 2D childred works well without layer
#onready var UI_layer = get_node("UI_elements_layer")
#onready var fps_logic = get_node("/root/game/game_logic/main_loop/fps_logic")
onready var fps_logic = get_node("/root/game/game_logic/ui_handler")

func _process(delta):
#	if UI_layer:
#		UI_anchors = get_tree().get_nodes_in_group("UI_anchors")
#		for anchor in UI_anchors:
#			if not is_position_behind(anchor.global_transform.origin):
#				var element_position = unproject_position(anchor.global_transform.origin)
#				var UI_element = anchor.get_children()[0]
#				UI_layer.reposition_element(UI_element, element_position)
#				# TODO: make this bad debug better
#				#UI_element.get_node("debug_label").text=str(element_position)
	
	# TODO: figure out the logic to seperate colliders for this from other in-game colliders, but just display all for now
	if $interact_ray.get_collider(): # and $interact_ray.get_collider().is_in_group("ui_info_area"):
		if not $interact_ray.get_collider().get("ui_text") == null:
			ui_handler.display_observed_object_info($interact_ray.get_collider().ui_text)
		else:
			ui_handler.display_observed_object_info($interact_ray.get_collider().name)
	else:
		ui_handler.display_observed_object_info(null)