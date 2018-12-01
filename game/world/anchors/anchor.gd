extends Position3D

var UI_element_path

# TODO: find a better name for this function
func spawn():
	add_to_group("UI_anchors")
	var UI_element_scene = load(UI_element_path)
	var UI_element = UI_element_scene.instance()
	UI_element.add_to_group("UI_elements")
	add_child(UI_element)