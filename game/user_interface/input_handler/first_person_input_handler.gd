extends Node

var enabled = 0

var can_toggle_camera = true

onready var game_settings = get_node("/root/game/settings/general_settings")
onready var mouse_speed = game_settings.mouse_speed

onready var game = get_node("/root/game")
onready var main_loop = get_node("/root/game/game_logic/main_loop")
onready var player = get_node("/root/game/game_world/actors/characters/player")
onready var player_camera_anchor = player.get_node("camera_anchor")

var controlled_vehicle = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func handle_fps_input(event):
	# TODO: find out if there is more elegant way to limit the x rotation
	if event is InputEventMouseMotion:
		player_camera_anchor.rotation.y -= event.relative.x*mouse_speed
		var new_x_rot = player_camera_anchor.rotation.x - event.relative.y*mouse_speed
		if new_x_rot > deg2rad(-90) and new_x_rot < deg2rad(100):
			player_camera_anchor.rotation.x = new_x_rot
	
	else:
		if event.is_action_pressed("change_perspective"):
			if can_toggle_camera:
				# TODO: figure out which script should be responsible for camera toggle
				pass
				#toggle_camera()
		
		if event.is_action_pressed("1"):
			player.select_item_from_category(1)
		
		if event.is_action_pressed("2"):
			player.select_item_from_category(2)
		
		if event.is_action_pressed("3"):
			player.select_item_from_category(3)
		
		if event.is_action_pressed("4"):
			player.select_item_from_category(4)
	
		if event.is_action_pressed("5"):
			player.select_item_from_category(5)
	
		if event.is_action_pressed("6"):
			player.select_item_from_category(6)
		
		if event.is_action_pressed("7"):
			player.select_item_from_category(7)
		
		if event.is_action_pressed("8"):
			player.select_item_from_category(8)
			
		if event.is_action_pressed("9"):
			player.select_item_from_category(9)
			
		if event.is_action_pressed("0"):
			player.select_item_from_category(0)
		
		if event.is_action_pressed("primary_fire"):
			player.activate_equipped_item("primary", "pressed")
			
		if event.is_action_released("primary_fire"):
			player.activate_equipped_item("primary", "released")
		
		if event.is_action_pressed("secondary_fire"):
			player.activate_equipped_item("secondary", "pressed")
			
		if event.is_action_released("secondary_fire"):
			player.activate_equipped_item("secondary", "released")
		
		if event.is_action_pressed("move_forward"):
			if controlled_vehicle: controlled_vehicle.accelerate()
			player.move_forward(true)
			
		if event.is_action_pressed("move_backwards"):
			if controlled_vehicle: controlled_vehicle.apply_reverse_engine_force()
			player.move_backwards(true)
			
		if event.is_action_pressed("move_left"):
			if controlled_vehicle: controlled_vehicle.steer_left()
			player.move_left(true)
			
		if event.is_action_pressed("move_right"):
			if controlled_vehicle: controlled_vehicle.steer_right()
			player.move_right(true)
			
		if event.is_action_pressed("jump"):
			player.jump()
		
		if event.is_action_released("move_forward"):
			if controlled_vehicle: controlled_vehicle.release_acceleration()
			player.move_forward(false)
			
		if event.is_action_released("move_backwards"):
			if controlled_vehicle: controlled_vehicle.release_acceleration()
			player.move_backwards(false)
			
		if event.is_action_released("move_left"):
			if controlled_vehicle: controlled_vehicle.release_steering()
			player.move_left(false)
			
		if event.is_action_released("move_right"):
			if controlled_vehicle: controlled_vehicle.release_steering()
			player.move_right(false)
			
		if event.is_action_pressed("unequip"):
			player.unequip()
			
		if event.is_action_pressed("drop_item"):
			player.drop_item()
			
		if event.is_action_pressed("confirm_selection"):
			player.equip_selected_item()
		
		# TODO: define this properly
		if event.is_action_pressed("test_click"):
			if controlled_vehicle: controlled_vehicle.exit_vehicle()
			player.click_item()
		
		if event.is_action_pressed("slow_time"):
			if main_loop.time_scale == 1:
				main_loop.change_time_scale(0.3)
			else:
				main_loop.change_time_scale(1)
