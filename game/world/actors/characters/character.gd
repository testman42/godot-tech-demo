extends KinematicBody

# logic variables
var is_enabled = true
var is_controlled = false
var is_in_vehicle = false

# debug variables
onready var debug = get_node("/root/game/settings/general_settings").debug
onready var debug_level = get_node("/root/game/settings/general_settings").debug_level

# external nodes
onready var main_loop = get_node("/root/game/game_logic/main_loop")
onready var fps_logic = get_node("/root/game/game_logic/main_loop/fps_logic")
onready var fps_settings = get_node("/root/game/settings/fps_settings")

# mechanics variables
var speed = 10
var can_play_hit_sound = true
var equipped_item = null
var moving_forward = false
var moving_backwards = false
var moving_left = false
var moving_right = false
var jump_counter = 1
var max_goal_speed = 20
var selected_item = 0

# player variables
# TODO: is it better to have inventory be single list and then filter items on the fly 
# or is it better to have categories already made and then merge them together when needed?
# so far dictionary seems to be better option
var inventory = {1:[], 2:[], 3:[], 4:[], 5:[], 6:[]}
var health = 100
var is_player_selecting_item = false
var currently_selected_item = null
var currently_selected_index = 0

#camera variables
var current_camera
var velocity = Vector3(0,0,0)
var pitch = 0
var yaw = PI/2
var gun_rot = Quat()

func _ready():
	set_physics_process(true)
	
func _process(delta):
	process_walk(delta)
	
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	process_gravity(delta)

func process_gravity(delta):
	velocity -=  Vector3(0,9.81,0) * delta

func process_walk(delta):
	if is_controlled:
		var old_y = velocity.y
		var goal_vel = Vector3(0,0,0)

		if moving_forward:
			goal_vel += (-$camera_anchor.global_transform.basis.z * Vector3(1,0,1)).normalized()
		if moving_backwards:
			goal_vel += ($camera_anchor.global_transform.basis.z * Vector3(1,0,1)).normalized()
		if moving_left:
			goal_vel += (-$camera_anchor.global_transform.basis.x * Vector3(1,0,1)).normalized()
		if moving_right:
			goal_vel += ($camera_anchor.global_transform.basis.x * Vector3(1,0,1)).normalized()
			
		if (goal_vel.length() > 1e-7): # don't divide by zero
			goal_vel = goal_vel.normalized()
			
		velocity = velocity.linear_interpolate(goal_vel * max_goal_speed, 0.1)
		velocity.y = old_y

func move_forward(boolean):
	moving_forward = boolean
	
func move_backwards(boolean):
	moving_backwards = boolean
	
func move_left(boolean):
	moving_left = boolean
	
func move_right(boolean):
	moving_right = boolean
	
func jump():
	velocity.y = 5

func take_control():
	var first_person_camera_scene = load("res://game/user_interface/cameras/first_person_camera/first_person_camera.tscn")
	var first_person_camera = first_person_camera_scene.instance()
	$camera_anchor.add_child(first_person_camera)
	first_person_camera.make_current()
	first_person_camera.add_to_group("current_camera")
	is_controlled = true
	set_process_input(true)

func stop_control():
	is_controlled = false
	set_process_input(false)

# TODO: this need to be reimplemented, a lot
# should most likely be moved to ui_handler.gd
func click_item():
	var object = get_node("camera_anchor/first_person_camera/interact_ray").get_collider()
	if debug and debug_level > 0: print("clicked on ", object)
	if object and object.has_method("click"):
		object.click(self)

# TODO: make this less spaghetti
func pick_up(object):
	if debug and debug_level > 0: print(self, " picked up ", object)
	var i = 1
	var found_category = 0
	for category in ["melee_weapons","tier1_weapons","tier2_weapons","tier3_weapons","tools"]:
		if object.is_in_group(category):
			if debug and debug_level > 0: print("adding ", object, " to ", category)
			inventory[i].append(object)
			found_category = 1
		i += 1
	# add object into "other items" category if it doesn't fit into any existing category
	if not found_category:
		inventory[6].append(object)
	if object.has_method("get_picked_up"): 	object.get_picked_up()
	if is_controlled:
		fps_logic.update_select_bar()

# TODO: make selector bar actually return selected value to here and then just equip whatever selector bar returned
# TODO: lol why does this need to be run twice in order to take effect?
func select_item_from_category(category_index):
	if len(inventory) > category_index and inventory[category_index]:
		if debug and debug_level > 0: print(len(inventory[category_index]), inventory[category_index][currently_selected_index])
		if fps_settings.instantly_cycle_through_items:
			print("switching instantly")
			currently_selected_item = inventory[category_index][currently_selected_index]
			currently_selected_index += 1
			is_player_selecting_item = true
			equip_selected_item()
		else:
			currently_selected_item = inventory[category_index][currently_selected_index]
			currently_selected_index += 1
			get_node("camera_anchor/first_person_camera/fps_preset/selector_bar").cycle_selection(category_index-1)
			is_player_selecting_item = true
	# revert to 0 if we reached end of list
	if len(inventory) > category_index and currently_selected_index+1 > len(inventory[category_index]):
		currently_selected_index = 0

func equip_selected_item():
	if currently_selected_item and is_player_selecting_item:
		print("equipping ", currently_selected_item.name)
		is_player_selecting_item = false
		if not fps_settings.instantly_cycle_through_items:
			currently_selected_index = 0
		equip(currently_selected_item)
		get_node("camera_anchor/first_person_camera/fps_preset/selector_bar").hide_all_groups()

# BACKUP: saved pasta in case things go horribly wrong
#func select_item_from_category(category_index):
#	if len(inventory) > category_index and inventory[category_index]:
#		if debug and debug_level > 0: print(len(inventory[category_index]), inventory[category_index][currently_selected_index])
#		currently_selected_item = inventory[category_index][currently_selected_index]
#		currently_selected_index += 1
#		get_node("camera_anchor/first_person_camera/fps_preset/selector_bar").cycle_selection(category_index-1)
#		is_player_selecting_item = true
#	# revert to 0 if we reached end of list
#	if len(inventory) > category_index and currently_selected_index+1 > len(inventory[category_index]):
#		currently_selected_index = 0
#
#func equip_selected_item():
#	if currently_selected_item and is_player_selecting_item:
#		print("equipping ", currently_selected_item.name)
#		is_player_selecting_item = false
#		currently_selected_index = 0
#		equip(currently_selected_item)
#		get_node("camera_anchor/first_person_camera/fps_preset/selector_bar").hide_all_groups()

func equip(item):
	if debug and debug_level > 0: print("Currently equipped: ", equipped_item)
	if equipped_item:
		equipped_item.hide()
		equipped_item = null
	equipped_item = item
	main_loop.reparent(item, $camera_anchor/item_anchor)
	make_equipped_visible()

# TODO: figure out how to properly structure this, so that items handle their own visibility
func make_equipped_visible():
	if debug and debug_level > 0: print("made ", equipped_item, " appear")
	if equipped_item: equipped_item.get_equipped()

func unequip():
	if equipped_item:
		if debug and debug_level > 0: print("unequipped current item")
		equipped_item.get_uneqipped()
		equipped_item = null

func activate_equipped_item(fire_mode, event):
	if equipped_item and equipped_item.has_method("activate") and not is_player_selecting_item:
		equipped_item.activate(fire_mode, event)
		
	
func drop_item(): #object):
	if equipped_item:
		var object = equipped_item
		if object.has_method("get_dropped"):
			object.get_dropped()
			main_loop.reparent(object, get_node("/root/game/game_world/actors/objects"))

# cease to be
# RIP parrot
func be_no_more():
	if debug and debug_level > 0: print(self, " has passed away. F")
	fps_logic.write_to_event_log(str(self.name) + " has passed away. F")
	if is_controlled:
		print("u ded, RIP in pepperoni")
		main_loop.pause_game()
	set_process(false)
	queue_free()

func can_apply_effect(effect):
	for i in ["damage", "heal", "fire", "shield"]:
		if effect == i:
			return true

# TODO: kill this bad code before it lays it's young
# actually, just make it more understandable
func apply_effect(effect, effect_properties):
	if effect == "damage":
		take_damage(effect_properties[0], effect_properties[1])

# TODO: rewrite this to handle the new "effect":[amount,type] system
func get_hit(damage_amount, type="normal"):
	take_damage(damage_amount, type)

func take_damage(amount, type):
	health -= amount
	if debug and debug_level > 0: print("OW! ", self," took ", amount," of ", type," damage. ", health, " HP left")
	if health <= -30:
		turn_into_giblets()
	if health <= 0:
		be_no_more()
	var health_indicator = $health_indicator_anchor
	if health_indicator:
		health_indicator.get_node("health_amount_indicator").set_state(health)

# TODO: actualy spawn giblets
func turn_into_giblets():
	if debug and debug_level > 0: print(self, " made a mess")

func _on_pick_up_area_area_entered(area):
	# group "pickups" does not work because other arreas besides pick_up_area also collide with character
	if area.get_name() == "pick_up_area":
		var object = area.get_parent()
		#if object.is_in_group("pickups"):
		pick_up(object)
