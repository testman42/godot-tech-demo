extends Node

var enabled = 0

var placing_building = 0
var just_selected = 0
var rotating_building = 0
var building_node
var building_location
var can_build = 0
var fast_move_start = Vector2()
var selecting_start = Vector2(0,0)
var fast_move = 0
var rotating_camera = 0

var camera_base

onready var main_loop = get_node("/root/game/game_logic/main_loop")
onready var rts_logic = get_node("/root/game/game_logic/main_loop/rts_logic")
onready var navigation = get_node("/root/game/game_world/environment/terrain/rts_map/navigation")

func _ready():
	pass

func prepare_rts_variables():
	camera_base = get_node("/root/game/game_world/cameras/rts_camera")
	
func handle_rts_input(event):
	
	# TODO: implement this in a more user friendly way
	if Input.is_key_pressed(KEY_TAB):
		main_loop.switch_game_mode("fps")
	
	# UI functionality
	if event.is_action("focus_on_home"):
		rts_logic.focus_on_home()
		
	if event.is_action_pressed("camera_rotate"):
		rotating_camera = 1
		camera_base.start_moving_camera()
		
	if event.is_action_released("camera_rotate"):
		rotating_camera = 0
		camera_base.stop_camera()
		
	if event.is_action_pressed("camera_fast_move"):
		fast_move = 1
		fast_move_start = event.position
		camera_base.start_moving_camera()
		
	if event.is_action_released("camera_fast_move"):
		fast_move = 0
		camera_base.stop_camera()
		
	if rotating_camera and event is InputEventMouseMotion:
		camera_base.rotate_camera(event.relative.x*0.005)
		
	if fast_move and event is InputEventMouseMotion:
		camera_base.change_direction(event.relative.x, event.relative.y)
	
	# construction placement 
	if placing_building and event.is_action_pressed("confirm_placement"):
		if !building_location and can_build:
			building_location = mouse2coords(event)
			placing_building = 0
			rotating_building = 1
		
	if rotating_building and event is InputEventMouseMotion:
		# causes irrelevant error bceuse of one pixel
		building_node.look_at(mouse2coords(event), Vector3(0,1,0))
		
	if rotating_building and event.is_action_released("confirm_placement"):
		building_node.add_to_group("rts_constructions")
		rts_logic.update_current_constructions_list()
		rts_logic.update_build_options()
		# TODO: figure out how to properly handle menu updating
		get_node("/root/game/game_world/cameras/rts_camera/rts_preset/construction_menu").update_construction_options()
		building_node.place()
		placing_building = 0
		rotating_building = 0
		building_location = 0
		
	if placing_building and event.is_action("cancel_placement"):
		rts_logic.cancel_building_placement()
		placing_building = 0
		rotating_building = 0
	
	if placing_building and event is InputEventMouseMotion:
		building_node.set_translation(mouse2coords(event))
		can_build = building_node.check_build_area()
		
	# unit selection handling
	var selected_group = get_tree().get_nodes_in_group("selected_units")
	if  selected_group.size() > 0 and event.is_action("order") and !just_selected:
		rts_logic.move_units_group_to(selected_group, mouse2coords(event))
	just_selected = 0
	
	if event.is_action_released("cancel_selection"):
		if !placing_building and fast_move_start.distance_to(event.position) < 3:
			rts_logic.deselect_all_selected_units()
	
#	if (event.is_action_pressed("select")) and !rotating_building and !placing_building:
#		selecting_start = event.position
#	if selecting_start.x > 0:
#		game.get_node("UI/HUD").draw_rect(selecting_start, event.position)
#		if event.is_action_released("select"):
#			if selecting_start.distance_to(event.position) > 3:
#				var camera = camera_base.get_node("Camera")
#				for unit in game.get_node("world/actors/units").get_children():
#					var loc_on_screen = camera.unproject_position(unit.get_translation())
#					if loc_on_screen.distance_to(event.position) < 20:
#						unit.select()
#					if is_point_in_rectangle(loc_on_screen, selecting_start, event.position):
#						unit.select()
#						unit.show_destination_line(1)
#						just_selected = 1
#			selecting_start = Vector2(0,0)
#			game.get_node("UI/HUD").hide_rect()
		
func mouse2coords(event):
	# TODO: reimplement this without the dirty offset hack
	# TODO: ask Godot dev team why this even happens, why does navigation behave as if it's at 0,0,0 and not as if it's translated
	var offset = navigation.get_parent().translation
	var near = camera_base.get_node("rts_camera").project_ray_origin(event.position) - offset
	var far = near + camera_base.get_node("rts_camera").project_ray_normal(event.position)*100
	var point = navigation.get_closest_point_to_segment(near, far)# + navigation.get_parent().translation
	return point + offset
	
func is_point_in_rectangle(point, rect_start, rect_end):
	var x = point.x
	var y = point.y
	if ( (rect_start.x > x and x > rect_end.x) or (rect_start.x  < x and x < rect_end.x )):
		if ( ( rect_start.y > y and y > rect_end.y) or (rect_start.y < y and y < rect_end.y )):
			return true
	return false