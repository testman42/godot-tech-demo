extends Node2D

# This is just an indicator of some timer, it is not the node that has countdown processing logic
# possible modes: full circle, doughnut circle, doughnut circle by segments, numeric display

var countdown_timer
var refresh_rate = 1
export var mode = 1

func _ready():
	countdown_timer = get_parent().get_parent().get_node("respawn_timer")
	# we hide the node at the start so that it does not show up in the upper left corner of the screen
	# it will get set to visible by other scripts once camera looks toward it
	hide()
	


func _process(delta):
	if countdown_timer:
		set_state(str(countdown_timer.time_left))

func set_state(state):
	$label.text=str(state)