extends Camera

var UI_anchors

onready var ui_handler = get_node("/root/game/game_logic/ui_handler")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

# TODO: implement additional checks for UI elements
# currently some UI elements can get stuck on the screen even if their anchor is behind the camera in case that player looks around very very quickly
func _process(delta):
	# only calculate element poitions form current camera perspective
	if current:
		UI_anchors = get_tree().get_nodes_in_group("UI_anchors")
		for anchor in UI_anchors:
			if not is_position_behind(anchor.global_transform.origin):
				var element_position = unproject_position(anchor.global_transform.origin)
				#var UI_element = anchor.get_children()[0]
				# in case there are multiple elements on one anchor
				for UI_element in anchor.get_children():
					if ui_handler.check_element(UI_element):
						ui_handler.current_UI_node.reposition_element(UI_element, element_position)
				# TODO: make this bad debug better
				#UI_element.get_node("debug_label").text=str(element_position)
	
#	# TODO: figure out the logic to seperate colliders for this from other in-game colliders, but just display all for now
#	if $interact_ray.get_collider(): # and $interact_ray.get_collider().is_in_group("ui_info_area"):
#		fps_logic.display_observed_object_info($interact_ray.get_collider().name)
#	else:
#		fps_logic.display_observed_object_info(null)