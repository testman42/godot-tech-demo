extends VehicleBody

var vehicle_name = "vehicle"
var can_be_entered = true
var is_controlled = false
var vehicle_mode = 2
var steering_direction = 0
var steering_speed = 20
var steering_limit = deg2rad(50)
var engine_force_applied = 0
var engine_force_limit = 100
var engine_force_reverse_limit = 50

var health = 100
var health_indicator
var ui_text = "press E to enter"

onready var fps_input_handler = get_node("/root/game/game_logic/input_handler/first_person_input_handler")

#func _ready():
#	set_mode(vehicle_mode)
#	engine_force = 0

func _process(delta):
	if is_controlled:
		if vehicle_mode == 1:
			pass
		if vehicle_mode == 2:
			if steering_direction:
				set_steering_value(steering+steering_direction*steering_speed)
			else:
				steering = 0
				
			match engine_force_applied:
				-1: set_engine_force(-50)
				0: set_engine_force(0)
				1: set_engine_force(100)
		
		

# guided mode is meant to be used in situations where other scripts determine vehicle's behaviour
# physics mode is meand to be used when vehicle has to behave like dictated by _process() and physics process
func set_mode(value):
	vehicle_mode = value
	match vehicle_mode:
		1: switch_to_guided_mode()
		2: switch_to_physics_mode()

func enter_vehicle():
	if can_be_entered:
		can_be_entered = false
		set_mode(2)
		take_control()

func exit_vehicle():
	can_be_entered = true
	stop_control()
	
func take_control():
	is_controlled = 1
	var tps_camera_scene = load("res://game/user_interface/cameras/third_person_camera/third_person_camera.tscn")
	var third_person_camera = tps_camera_scene.instance()
	$camera_anchor.add_child(third_person_camera)
	third_person_camera.make_current()
	fps_input_handler.controlled_vehicle = self

func stop_control():
	is_controlled = 0
	engine_force = 0
	$camera_anchor.remove_child($camera_anchor/third_person_camera)

func switch_to_guided_mode():
	mode = RigidBody.MODE_KINEMATIC
	#set_physics_process(false)

func switch_to_physics_mode():
	mode = RigidBody.MODE_RIGID
	#set_physics_process(true)

func accelerate():
	engine_force_applied = 1

func release_acceleration():
	engine_force_applied = 0

func apply_reverse_engine_force():
	engine_force_applied = -1

func steer_left():
	steering_direction = 1

func steer_right():
	steering_direction = -1
	
func release_steering():
	steering_direction = 0

# set the amount of steering
# thank you baybatu from Github
func set_steering_value(value):
	steering = max(min(value, steering_limit), -steering_limit)
	
func set_engine_force(value):
	engine_force = max(min(value, engine_force_limit), -engine_force_reverse_limit)
	
func click(object):
	print(object, " clicked on me")
	enter_vehicle()
	object.is_controlled = 0

# TODO: rewrite this to handle the new "effect":[amount,type] system
func get_hit(damage_amount, type="normal"):
	take_damage(damage_amount, type)

func take_damage(amount, type):
	health -= amount
	#if debug and debug_level > 0: print("OW! ", self," took ", amount," of ", type," damage. ", health, " HP left")
	if health <= -30:
		pass
	if health <= 0:
		be_no_more()
	#var health_indicator = $health_indicator_anchor
	if health_indicator:
		health_indicator.get_node("health_amount_indicator").set_state(health)

# cease to be
# RIP parrot
func be_no_more():
	#if debug and debug_level > 0: print(self, " has exloded.")
	#fps_logic.write_to_event_log(str(self.name) + " has exploded.")
	if is_controlled:
		pass
		# TODO: implement code to either eject player or also call be_no_more() on player
	set_process(false)
	queue_free()