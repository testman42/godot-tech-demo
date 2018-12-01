extends Node2D

# this is just indicator and does not do any actual processing

export var mode = 1

var health_amount

func _ready():
	health_amount = get_parent().get_parent().health
	if health_amount:
		$health_amount_percent.max_value = health_amount
		set_state(health_amount)
	hide()

func set_state(state):
	$health_amount_percent.value = state
	$health_amount_number.text = str(state)
