# This script is intended to store core functions
# > script is called "main_loop"
# > it's not even a loop
# lol
# TODO: find proper name for this node

extends Node

# import required settings
onready var debug = get_node("/root/game/settings/general_settings").debug

# variables
var current_game_mode = "fps"
var current_HUD_preset = "fps"
var HUD_enabled = 1
var time_scale = 1

# variables used to store nodes
var current_HUD_node
var UI_layer

func _ready():
	set_process_input(true)
	get_tree().set_pause(false)
	switch_game_mode("fps")

func pause_game():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	# TODO: lol why doesn't this work from here but does from input_handler.gd?
	get_tree().set_pause(true)
	display_pause_menu()

func resume_game():
	get_tree().set_pause(false)
	if current_game_mode == "fps":
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func switch_game_mode(game_mode):
	match game_mode:
		"fps": switch_to_first_person_mode()
		"rpg": switch_to_first_person_mode("rpg")
		"rts": switch_to_rts_mode()
		#"drive":  ????
	current_game_mode = game_mode

func switch_to_first_person_mode(camera_preset = "fps"):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for camera in get_tree().get_nodes_in_group("current_camera"):
		camera.remove_from_group("current_camera")
	get_node("../../game_world/actors/characters/player").take_control()
	get_node("/root/game/game_logic/input_handler").prepare_first_person_variables()
	get_node("/root/game/game_logic/ui_handler").switch_to_UI_preset(camera_preset)
	#switch_to_UI_elements_preset("fps")

func switch_to_rts_mode(camera_preset = "rts"):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	for camera in get_tree().get_nodes_in_group("current_camera"):
		camera.remove_from_group("current_camera")
	var rts_camera_scene = load("res://game/user_interface/cameras/rts_camera/rts_camera.tscn")
	var rts_camera = rts_camera_scene.instance()
	get_node("../../game_world/cameras").add_child(rts_camera)
	rts_camera.name = "rts_camera"
	rts_camera.make_current_camera()
	rts_camera.add_to_group("current_camera")
	get_node("/root/game/game_logic/input_handler/rts_input_handler").prepare_rts_variables()
	get_node("/root/game/game_logic/ui_handler").switch_to_UI_preset(camera_preset)
	#switch_to_UI_elements_preset("rts")

# TODO: should there be some UI handler (something that relays info between UI and game world)?
# otherwise showing hit-markers when hitscan connects with target requires *a lot* of jumps
# unless we do hacky hacky ways of connecting them directly

# TODO: actually, whole codebase should be reworked because there are *way* too many get_node() calls being repeated

# select which non-moving UI elements to display on screen
#func switch_to_UI_preset(HUD_preset):
#	if debug: print("switching to ", HUD_preset)
#	disable_HUD()
#	match HUD_preset:
#		"fps":
#			var fps_preset_scene = load("res://game/user_interface/UI_presets/fps_preset/fps_preset.tscn")
#			var fps_preset = fps_preset_scene.instance()
#			current_HUD_node = fps_preset
#			get_node("../../game_world/actors/characters/player/camera_anchor/first_person_camera").add_child(fps_preset)
#		"rpg": 
#			var rpg_preset_scene = load("res://game/user_interface/UI_presets/rpg_preset/rpg_preset.tscn")
#			var rpg_preset = rpg_preset_scene.instance()
#			current_HUD_node = rpg_preset
#			get_node("../../game_world/actors/characters/player/camera_anchor/first_person_camera").add_child(rpg_preset)
#		"rts":
#			var rts_preset_scene = load("res://game/user_interface/UI_presets/rts_preset/rts_preset.tscn")
#			var rts_preset = rts_preset_scene.instance()
#			current_HUD_node = rts_preset
#			get_node("/root/game/game_world/cameras/rts_camera").load_HUD_preset(rts_preset)
#	current_HUD_preset = HUD_preset
#
## select which movable UI elements to display:
#func switch_to_UI_elements_preset(mode):
#	# TODO: implement more UI modes
#	# TODO: rework this in way more elegant way
#	var UI_layer_scene = load("res://game/user_interface/UI_presets/UI_elements_layer.tscn")
#	UI_layer = UI_layer_scene.instance()
#	get_node("../../game_world/actors/characters/player/camera_anchor/first_person_camera").add_child(UI_layer)

#func show_HUD():
#	current_HUD_node.show()
#
#func hide_HUD():
#	current_HUD_node.hide()
#
#func show_UI_layer():
#	UI_layer.show()
#
#func hide_UI_layer():
#	UI_layer.hide()
#
#func enable_HUD():
#	switch_to_HUD_preset(current_HUD_preset)
#
#func disable_HUD():
#	if current_HUD_node: current_HUD_node.queue_free()

func display_pause_menu():
	var pause_menu_scene = load("res://game/user_interface/menus/pause_menu/pause_menu.tscn")
	var pause_menu = pause_menu_scene.instance()
	get_tree().get_nodes_in_group("current_camera")[0].add_child(pause_menu)

# TODO: should this even be in main?
#func spawn_node(nodepath, location = 0):
#	var unit_scene = load(nodepath)
#	var unit = unit_scene.instance()
#	# TODO: make unit logic use groups instead of scene tree
#	get_node("/root/game/game_world/actors/units").add_child(unit)
#	unit.add_to_group("units")
#	#check if location is provided, otherwise spawn at Gear of Generating
#	if typeof(location) == TYPE_VECTOR3 :
#		unit.set_translation(location)
#	else:
#		unit.set_translation(get_node("/root/game/game_world/actors/constructions/gear_of_generating").get_translation())
#	unit._ready()

func reparent(node, new_parent):
	var node_parent = node.get_parent()
	node_parent.remove_child(node)
	new_parent.add_child(node)

# TODO: figure out why projectile speed does not change despite different time scale
func change_time_scale(scale):
	time_scale = scale
	Engine.time_scale = scale

# this is insane crazy debug visualization tool and is not meant to be used for anything besides bad sphagetti code debugging
func draw_debug_line(vector1, vector2):
	var im = ImmediateGeometry.new()
	var material = SpatialMaterial.new()
	im.set_material_override(material)
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	im.add_vertex(vector1)
	im.add_vertex(vector2)
	im.end()
	get_node("/root/game/game_world").add_child(im)
