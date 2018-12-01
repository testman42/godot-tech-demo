extends RigidBody

var weapon_type
var clip_size
var current_clip_ammo

# TODO: find some more efficient way to determine if object can be picked up. Most likely groups
export var is_pickup = true

func _ready():
	add_to_group("pickups")

func get_picked_up():
	$pick_up_area/collision.disabled = true
	$world_collision.disabled = true
	mode = RigidBody.MODE_KINEMATIC
	translation = Vector3(0,0,0)
	rotation = Vector3(0,deg2rad(180),0)
	if get_parent().has_method("item_taken"):
		get_parent().item_taken()
	hide()

func get_dropped():
	$pick_up_area/collision.disabled = false
	$world_collision.disabled = false
	mode = RigidBody.MODE_RIGID
	# TODO: how would we drop this properly in front of player?
	translation = Vector3(0,0,0)
	show()

func get_equipped():
	show()

func get_unequipped():
	hide()

func activate(mode, event="pressed"):
	pass

