# node used for display and placement logic of all UI elements

extends Node2D

# which elements to display
# go by elements instead of elementy types because player does not necesarily want to see ALL elements of same type
# (for example, selected units in RTS mode should display health bar while those not selected should not)
var visible_elements = []
var visible_element_groups = []

#func _process(delta):
#	active_UI_elements = get_tree().get_nodes_in_group("UI_elements")
#	for element in active_UI_elements:
#		print(unproject_position(element))

# TODO: find a way to scale elements
func reposition_element(element, element_position_vector, element_scale=1):
	if not element.visible:
		element.show()
	element.set_global_position(element_position_vector)

func show_element(element):
	visible_elements.append(element)

func hide_element(element):
	visible_elements.remove(element)
	
func show_group(group):
	visible_element_groups.append(group)
	
func hide_group(group):
	visible_element_groups.remove(group)