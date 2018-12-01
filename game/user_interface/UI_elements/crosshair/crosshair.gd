extends Node2D

var current_crosshair_shape = "cross"

# TODO: is it better to re-color lines each time or to have multiple instances of hit-markers and just hide/show those?
# basically a question if it's better to consume memory or processing resources

#func _ready():
#	set_process_input(true)
#
#func _input(event):
#	if event.is_action_pressed("1"):
#		show_hit_marker()
#	if event.is_action_pressed("2"):
#		show_hit_marker(true)

func change_crosshair_colour_to(colour):
	pass

func change_crosshair_shape_to(shape):
	get_node("center/"+current_crosshair_shape).hide()
	get_node("center/"+shape).show()
	current_crosshair_shape = shape
	
# TODO: bloody hell this is hacked together badly. Find more elegant solution.
func show_hit_marker(big=false, red=false):
	var size = "big" if big else "small"
	var colour = "red" if red else "white"
	get_node("center/"+size+"_"+colour+"_hit_marker").show()
	yield(get_tree().create_timer(0.1),"timeout")
	get_node("center/"+size+"_"+colour+"_hit_marker").hide()