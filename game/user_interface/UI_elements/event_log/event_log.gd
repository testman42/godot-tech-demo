extends Node2D

# TODO: calculate this accoring to log window size
# TODO: actually make messages disappear after specified time

var line_limit = 6
var time_to_display = 10

onready var log_window = get_node("log_window")

func write_line(string):
	if len(log_window.get_children()) > line_limit-1:
		log_window.get_children()[0].queue_free()
	var new_line = Label.new()
	new_line.text = string
	log_window.add_child(new_line)