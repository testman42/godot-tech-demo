extends "res://game/world/actors/objects/constructions/construction.gd"


func _ready():
	ui_name = "Cone of construction"
	health = 800
	build_radius = 30
	building_area = 1.5
	power = 0
	price = 1000
	#default_material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.226624,0.260188,0.617188))