extends Node

# input handling should be handled so that it firstly checks if input was meant for HUD.
# if not, then relay input to game.

# should be used only in very specific cases
var override_general_input = 0

# import settings
onready var game_settings = get_node("/root/game/settings/general_settings")
onready var mouse_speed = game_settings.mouse_speed

var player
var player_camera_anchor
var camera_base

onready var game = get_node("/root/game")
onready var main_loop = get_node("/root/game/game_logic/main_loop")

onready var fps_input_handler = get_node("/root/game/game_logic/input_handler/first_person_input_handler")
onready var rts_input_handler = get_node("/root/game/game_logic/input_handler/rts_input_handler")

func _ready():	
	set_process_input(true)
	
func _input(event):

	if Input.is_key_pressed(KEY_ESCAPE):
		# TODO: lol why does this work nice if it's in input_handler.gd but doesn't work well if called from main loop?
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		main_loop.display_pause_menu()
		get_tree().set_pause(true)

	match main_loop.current_game_mode:
		"fps": handle_fps_input(event)
		"rts": handle_rts_input(event)

func prepare_first_person_variables():
	player = get_node("/root/game/game_world/actors/characters/player")
	player_camera_anchor = player.get_node("camera_anchor")

func handle_fps_input(event):
	fps_input_handler.handle_fps_input(event)

func handle_rts_input(event):
	rts_input_handler.handle_rts_input(event)

func toggle_camera():
	if player_camera_anchor.get_node("first_person_camera").current:
		player_camera_anchor.get_node("third_person_camera").make_current()
	else:
		player_camera_anchor.get_node("first_person_camera").make_current()