extends "res://game/world/actors/objects/constructions/construction.gd"

func _ready():
	ui_name = "Tetrahedron of transmutation"
	health = 200
	build_radius = 6
	building_area = 1.5
	power = -10
	price = 500
	#default_material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.847656,0.736732,0.403961))

func place():
	.place()
	add_to_group("economy")
	spawn_collector()

func spawn_collector():
	var collector_location = get_node("collector_spawn").get_global_transform()
	collector_location = collector_location.origin
	rts_logic.spawn_unit("res://game/world/actors/objects/vehicles/tanks/resource_collector/resource_collector.tscn", collector_location, rotation)