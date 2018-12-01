extends Control

onready var buildings_grid_scene
onready var units_grid_scene
onready var build_info
onready var rts_logic

var number_of_building_tabs = 0
var number_of_vehicle_tabs = 0

func _ready():
	#print(get_path())
	buildings_grid_scene = preload("res://game/user_interface/UI_elements/build_menu/buildings_grid.tscn")
	units_grid_scene = preload("res://game/user_interface/UI_elements/build_menu/units_grid.tscn")
	build_info = get_node("build_info")
	rts_logic = get_node("/root/game/game_logic/main_loop/rts_logic")
	update_construction_options()

func set_building_tabs(amount):
	number_of_building_tabs = amount
	
func set_vehicle_tabs(amount):
	number_of_vehicle_tabs = amount

func update_construction_options():
	var buildings_tab = TabContainer.new()
	buildings_tab.set_name("Buildings")
	
	# TODO: this is very bad. Rework tech tree so that it returns "categories", allowing for easy creation of new un-specified categories
	number_of_building_tabs = rts_logic.current_constructions.count(0) # Cone of construction
	number_of_vehicle_tabs = rts_logic.current_constructions.count(3) # Gear of generating

	for i in range(number_of_building_tabs):
		var number_tab = GridContainer.new()
		number_tab.set_name(str(i+1))
		var buildings_grid = buildings_grid_scene.instance()
		number_tab.add_child(buildings_grid)
		buildings_tab.add_child(number_tab)
		connect_signals(buildings_grid)

		# TODO: rework this so that menu is generated automatically from the given scenes, so that it doesn't have to be pre-made
		for construction in rts_logic.possible_constructions:
			match construction:
				0: buildings_grid.get_node("cc").show()
				1: buildings_grid.get_node("rr").show()
				2: buildings_grid.get_node("tt").show()
				3: buildings_grid.get_node("gg").show()
				4: buildings_grid.get_node("oo").show()
#				6: pass
#				7: pass

	var units_tab = TabContainer.new()
	units_tab.set_name("Units")
	for i in range(number_of_vehicle_tabs):
		var number_tab = GridContainer.new()
		number_tab.set_name(str(i+1))
		var units_grid = units_grid_scene.instance()
		number_tab.add_child(units_grid)
		units_tab.add_child(number_tab)
		connect_signals(units_grid)

		for construction in rts_logic.possible_constructions:
			match construction:
				5: units_grid.get_node("collector").show()
				6: units_grid.get_node("basic_tank").show()
				7: units_grid.get_node("serious_tank").show()
				#4: units_grid.get_node("gfm").show()
	
	# clear previous state before adding new state
	var current_tabs = get_node("type_select").get_children()
	for child in current_tabs:
		get_node("type_select").remove_child(child)

	get_node("type_select").add_child(buildings_tab)
	get_node("type_select").add_child(units_tab)

# lol this needs better variable names
func connect_signals(node):
	for child in node.get_children():
		child.connect("pressed", self, "_on_"+child.get_name()+"_pressed")
		child.connect("mouse_entered", self, "_on_"+child.get_name()+"_mouse_enter")
		child.connect("mouse_exited", self, "_on_"+child.get_name()+"_mouse_exit")

# TODO: this needs to be very much reworked and de-hardcoded
func _on_rr_pressed():
	rts_logic.start_placing_building(1)
	
func _on_tt_pressed():
	rts_logic.start_placing_building(2)
	
func _on_gg_pressed():
	rts_logic.start_placing_building(3)

func _on_cc_pressed():
	rts_logic.start_placing_building(0)
	
func _on_oo_pressed():
	rts_logic.start_placing_building(4)
	
func _on_collector_pressed():
	rts_logic.spawn_unit(rts_logic.constructions_indexes[6], rts_logic.unit_spawn_locations[0])
	
func _on_basic_tank_pressed():
	rts_logic.spawn_unit(rts_logic.constructions_indexes[5], rts_logic.unit_spawn_locations[0])

# possible other fun names:
# behemoth tank
# giant tank
# colossus tank
# goliath tank
func _on_serious_tank_pressed():
	rts_logic.spawn_unit(rts_logic.constructions_indexes[6], rts_logic.unit_spawn_locations[0])
	
# giant mech could also be "cyclops"

# idea for naval unit: titanic
# autonomus battleship that when damaged to 30% health splits in two parts that act as big torpedoes



# this allows RTS logic script to update the menu
func _refresh():
	upddate_construction_options()

#HALP PLS: how do we make this more elegant instead of repeating the function for each button?
func _on_rr_mouse_enter():
	build_info.set_text("Rectangular Reactor")

func _on_tt_mouse_enter():
	build_info.set_text("Tetrahedron of transmutation")

func _on_gg_mouse_enter():
	build_info.set_text("Gear of generating")

func _on_cc_mouse_enter():
	build_info.set_text("Cone of construction")

func _on_oo_mouse_enter():
	build_info.set_text("Orb of observation")

func _on_collector_mouse_enter():
	build_info.set_text("Collector")
	
func _on_basic_tank_mouse_enter():
	build_info.set_text("Basic Tank")
	
func _on_serious_tank_mouse_enter():
	build_info.set_text("Serious Tank")


func _on_rr_mouse_exit():
	build_info.set_text("")

func _on_tt_mouse_exit():
	build_info.set_text("")

func _on_gg_mouse_exit():
	build_info.set_text("")

func _on_cc_mouse_exit():
	build_info.set_text("")

func _on_oo_mouse_exit():
	build_info.set_text("")

func _on_collector_mouse_exit():
	build_info.set_text("")
	
func _on_basic_tank_mouse_exit():
	build_info.set_text("")
	
func _on_serious_tank_mouse_exit():
	build_info.set_text("")
	

