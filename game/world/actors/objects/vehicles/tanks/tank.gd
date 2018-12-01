extends "res://game/world/actors/objects/vehicles/vehicle.gd"


func _ready():
	steering_limit = deg2rad(50)
	set_mode(2)

#func _process(delta):
#	pass