extends Node

# import required settings
onready var debug = get_node("/root/game/settings/general_settings").debug
onready var destination_lines_enabled = get_node("/root/game/settings/rts_settings").destination_lines_enabled

onready var main_loop = get_node("/root/game/game_logic/main_loop")

var current_game_mode = "fps"
var current_UI_preset = "fps"
var UI_enabled = 1
var visible_ui_elements = []

# variables used to store nodes
var current_UI_node

#func _ready():
#	pass

#func _process(delta):
#	pass

# select which non-moving UI elements to display on screen
func switch_to_UI_preset(UI_preset):
	if debug: print("switching to ", UI_preset)
	disable_current_UI()
	match UI_preset:
		"fps":
			var fps_preset_scene = load("res://game/user_interface/UI_presets/fps_preset/fps_preset.tscn")
			var fps_preset = fps_preset_scene.instance()
			current_UI_node = fps_preset
			get_node("../../game_world/actors/characters/player/camera_anchor/first_person_camera").add_child(fps_preset)
		"rpg": 
			var rpg_preset_scene = load("res://game/user_interface/UI_presets/rpg_preset/rpg_preset.tscn")
			var rpg_preset = rpg_preset_scene.instance()
			current_UI_node = rpg_preset
			get_node("../../game_world/actors/characters/player/camera_anchor/first_person_camera").add_child(rpg_preset)
		"rts":
			var rts_preset_scene = load("res://game/user_interface/UI_presets/rts_preset/rts_preset.tscn")
			var rts_preset = rts_preset_scene.instance()
			current_UI_node = rts_preset
			get_node("/root/game/game_world/cameras/rts_camera").add_child(rts_preset)
	current_UI_preset = UI_preset

func show_UI():
	current_UI_node.show()

func hide_UI():
	current_UI_node.hide()

func enable_UI():
	switch_to_UI_preset(current_UI_preset)

func disable_current_UI():
	if current_UI_node: current_UI_node.queue_free()

# TODO: make this actually work
# displays info if info string is not null
func display_observed_object_info(info_string):
	var hover_info_label = get_node("/root/game/game_world/actors/characters/player/camera_anchor/first_person_camera/fps_preset/hover_info")
	# TODO: find out why RTS button made this a null instance
	if hover_info_label: hover_info_label.set_text(info_string)

# TODO: come up with better name for this function
# check if element is supposed to be displayed or not
func check_element(element):
	# check if element is in one of the groups that should be shown
	for group in current_UI_node.visible_element_groups:
		if element.is_in_group(group):
			return true
	if element in current_UI_node.visible_elements:
		return true
	return false