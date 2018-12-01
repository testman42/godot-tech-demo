extends "res://game/world/actors/objects/constructions/construction.gd"


func _ready():
	ui_name = "Rectangular reactor"
	health = 200
	build_radius = 15
	building_area = 1.5
	power = 50
	price = 100
	#default_material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.392908,0.295258,0.585938))