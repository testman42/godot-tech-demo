extends StaticBody

export var ui_name = "name" # name to be used in UI
export var max_health = 0
export var build_radius = 0
export var building_area = 0
export var power = 0  # +int gives power, -int consumes power, 0 does not affect power
export var price = 0
var state = "" # can be "placing", "rotating" and "placed", maybe add "destroyed" to keep rubble
var health = 0
var buildings = 0
var default_material = SpatialMaterial.new()
var red = SpatialMaterial.new()
var is_red = 0

onready var rts_logic = get_node("/root/game/game_logic/main_loop/rts_logic")

func _ready():
	red.albedo_color = Color(0.585938,0.169373,0.169373)
#
#func start_placing():
#	var UI = get_node("/root/game/UI")
#	var m = FixedMaterial.new()
#	set_translation(Vector3(0,-9001,0))
#	get_node("mesh").set_material_override(m)
#	show()
#	UI.placing_building = 1
#	UI.building_node = self
#	UI.get_node("HUD").hide_rect()
#	buildings = get_tree().get_nodes_in_group("available_build_area")
#
##function that determines if location is suitable for this construction to be placed
##TBH I have no good idea how to implement this, only bad ones
#func check_if_suitable_terrain():
#	pass
#
#func check_build_area():
#	var can_build = 0
#	paint_red()
#	var location = Vector2(get_translation().x, get_translation().z)
#	for building in buildings:
#		var building_location = Vector2(building.get_translation().x, building.get_translation().z)
#		if location.distance_to(building_location) < building_area+building.building_area:
#			can_build = 0
#			paint_red()
#			break
#		if location.distance_to(building_location) < building.build_radius:
#			can_build = 1
#			get_node("mesh").set_material_override(default_material)
#			is_red = 0
#	return can_build
#
#func place():
#	# TODO: check if those groups are used correctly
#	add_to_group("rts_constructions")
#	add_to_group("buildings")
#	add_to_group("available_build_area")
#	get_node("mesh").set_material_override(default_material)
#
#
#func show_build_area():
#	pass
#
#func paint_red():
#	if !is_red:
#		get_node("mesh").set_material_override(red)
#		is_red = 1
#
###################################################################################################### to be backported:


# actor properties
#export var health = 100
#
#var state = "" #can be "placing", "rotating" and "placed", maybe add "destroyed" to keep rubble
#var build_radius = 0
#var building_area = 0
##export var power = 0 #+int gives power, -int consumes power, 0 does not affect power
##export var price = 0
##var max_health = 0
#var buildings = 0
#var default_material = SpatialMaterial.new()
#var red = SpatialMaterial.new()
#var is_red = 0
#
#func _ready():
#	red.albedo_color = Color(0.585938,0.169373,0.169373)
#	pass

func start_placing():
	var input_handler = get_node("/root/game/game_logic/input_handler/rts_input_handler")
	var material = SpatialMaterial.new()
	set_translation(Vector3(0,-9001,0))
	get_node("mesh").set_material_override(material)
	show()
	input_handler.placing_building = 1
	input_handler.building_node = self
	buildings = get_tree().get_nodes_in_group("available_build_area")

# function that determines if location is suitable for this construction to be placed
# TBH I have no good idea how to implement this, only bad ones
func check_if_suitable_terrain():
	pass

func check_build_area():
	var can_build = 0
	paint_red()
	var location = Vector2(get_translation().x, get_translation().z)
	for building in buildings:
		# check if too close to any of the already placed buildings, so that they don't overlap
		var building_location = Vector2(building.get_translation().x, building.get_translation().z)
		if location.distance_to(building_location) < building_area+building.building_area:
			can_build = 0
			paint_red()
			break
		# check if within permitted construction area
		if location.distance_to(building_location) < building.build_radius:
			can_build = 1
			get_node("mesh").set_material_override(default_material)
			is_red = 0
	return can_build

func place():
	add_to_group("rts_constructions")
	add_to_group("available_build_area")
	#print("enabling collision")
	get_node("CollisionShape").disabled = false
	get_node("mesh").set_material_override(default_material)

# lol this is not something that building should handle
#func show_build_area():
#	pass

func can_apply_effect(effect):
	for i in ["damage", "heal", "repair", "shield"]:
		if effect == i:
			return true

# TODO: kill this bad code before it lays it's young
# actually, just make it more understandable
func apply_effect(effect, effect_properties):
	if effect == "damage":
		take_damage(effect_properties[0], effect_properties[1])

func get_hit(damage_amount, type="normal"):
	take_damage(damage_amount, type)

# TODO: figure out if there could be a class that characters and buildings all derive from
func take_damage(amount, type):
	health -= amount
	if health <= 0:
		blow_up()

func blow_up():
	remove_from_group("rts_constructions")
	remove_from_group("available_build_area")
	rts_logic.update_build_options()
	print(self.name ," goes boom")
	queue_free()


func paint_red():
	if !is_red:
		get_node("mesh").set_material_override(red)
		is_red = 1