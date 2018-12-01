extends Node

var building_node
var destination_lines_enabled
var constructions_indexes = {}
var current_constructions = []
var possible_constructions = []
var tech_tree = {}
# TODO: de-hardcode this ASAP
var unit_spawn_locations = []

onready var main_loop = get_node("..")
onready var home_location = get_node("/root/game/game_world/actors/objects/constructions/cone_of_construction").get_translation()

func _ready():
	populate_constructions_indexes()
	populate_tech_tree()
	update_build_options()
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func load_rts_settings():
	pass
	#destination_lines_enabled

func focus_on_home():
	pass

func confirm_building_placement():
	pass

func cancel_building_placement():
	building_node.free()

func deselect_all_selected_units():
	for unit in get_tree().get_nodes_in_group("selected_units"):
		unit.deselect()

func update_build_options():
	update_current_constructions_list()
	
	# clear list before filling it again
	possible_constructions.clear()
	for key in tech_tree:
		var can_build = 1
		for i in tech_tree[key]:
			if not i in current_constructions:
				can_build = 0
		if can_build:
			possible_constructions.append(key)

# Coordinates are Vector2
func can_build_at(coordinates):
	var can_build = false
	for building in get_tree().get_nodes_in_group("available_construction_area"):
		# PSEUDOCODE: if distance between coodrdinates and building < buidling.build_area_radius: return true
		pass

func start_placing_building(construction_index):
	var node = load(constructions_indexes[construction_index])
	building_node = node.instance()
	#could do it inside start_placing() but just to prevent any single-frame collisions
	building_node.get_node("CollisionShape").disabled = true
	# could I just load(building_nodepath).instance() ?
	get_node("/root/game/game_world/actors/objects/constructions").add_child(building_node)
	#to hide the split-second appearance at 0,0,0
	building_node.hide()
	building_node.start_placing()

func move_units_group_to(group, coordinates):
	for unit in group:
		unit.set_destination(coordinates)
		if destination_lines_enabled:
			unit.show_destination_line(1)

# function that fills in the dictionary that serves as the index of all possible constructions
func populate_constructions_indexes():
	constructions_indexes[0] = "res://game/world/actors/objects/constructions/cone_of_construction/cone_of_construction.tscn"
	constructions_indexes[1] = "res://game/world/actors/objects/constructions/rectangular_reactor/rectangular_reactor.tscn"
	constructions_indexes[2] = "res://game/world/actors/objects/constructions/tetrahedron_of_transmutation/tetrahedron_of_transmutation.tscn"
	constructions_indexes[3] = "res://game/world/actors/objects/constructions/gear_of_generating/gear_of_generating.tscn"
	constructions_indexes[4] = "res://game/world/actors/objects/constructions/orb_of_observation/orb_of_observation.tscn"
	constructions_indexes[5] = "res://game/world/actors/objects/vehicles/tanks/basic_tank/tank.tscn"
	constructions_indexes[6] = "res://game/world/actors/objects/vehicles/tanks/resource_collector/resource_collector.tscn"
	constructions_indexes[7] = null

# function that declares tech tree. This is not required function, tech tree could be provided some other way
func populate_tech_tree():
	
	# TODO: this is bad, rework this so that it contains categories and which categories those categories provide
	# entry structure: tech_tree[constructions_indexes_id] = list_of_reqired_indexes
	tech_tree[0] = [2, 3] #["Buildings", "conyard", [2, 3]]
	tech_tree[1] = [0]
	tech_tree[2] = [0, 1]
	tech_tree[3] = [0, 2]
	tech_tree[4] = [0, 2]
	tech_tree[5] = [3]
	tech_tree[6] = [3]
	tech_tree[7] = [3, 4]
	
	# reworked tree:
	# o fug, how do I structure this properly?
#	tech_tree["buildings"] = ["buildings_tier_1"] #read: conyard
#	tech_tree["buildings_tier_1"] = ["buildings_tier_2"]
#	tech_tree["buildings_tier_2"] = ["buildings_tier_3", "units_tier_1"]
#	tech_tree["buildings_tier_3"] = ["buildings_tier_4", "units_tier_2"]

func update_current_constructions_list():
	#clear list before refreshing it to avoid multiplication
	current_constructions.clear()
	for construction in get_tree().get_nodes_in_group("rts_constructions"):
		for key in constructions_indexes:
			if constructions_indexes[key] == construction.get_filename():
				current_constructions.append(key)
				# TODO: rework this so that it works for all categories, not just hardcoded ones
				if key == 3:
					unit_spawn_locations.append(construction.get_global_transform().origin+Vector3(0,3,0))

func spawn_unit(nodepath, unit_location = 0, unit_rotation = 0):
	var unit_scene = load(nodepath)
	var unit = unit_scene.instance()
	if unit_rotation: unit.rotation = unit_rotation
	# TODO: make unit logic use groups instead of scene tree
	get_node("/root/game/game_world/actors").add_child(unit)
	unit.add_to_group("rts_units")
	#check if location is provided, otherwise spawn at Gear of Generating
	#if typeof(unit_location) == TYPE_VECTOR3 :
	# this assumes that nobody will put something else other than Vector3 into unit_locationgh
	if unit_location:
		unit.set_translation(unit_location)
	else:
		# in current state, this should never be the case, as unit_location is always given
		#unit.set_translation(get_node("/root/game/game_world/actors/constructions/gear_of_generating").get_translation())
		pass
	unit._ready()