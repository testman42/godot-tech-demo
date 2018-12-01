extends "res://game/world/actors/objects/weapons/weapon.gd"

var actions = []
var primary_fire_active
var secondary_fire_active
var primary_timer = Timer.new()
var secondary_timer = Timer.new()

func _ready():
	var action1 = load("res://game/world/actors/mechanics/projectiles/plazma_projectile/plazma_projectile.tscn")
	var action2 = load("res://game/world/actors/mechanics/projectiles/big_plazma_projectile/big_plazma_projectile.tscn")
	actions.append(action1)
	actions.append(action2)
	# define the rate of fire
	primary_timer.set_wait_time(0.15)
	secondary_timer.set_wait_time(1)
	self.add_child(primary_timer)
	self.add_child(secondary_timer)

func _process(delta):
	if primary_fire_active and not secondary_fire_active and primary_timer.time_left == 0:
		fire_primary()
		primary_timer.start()
		yield(primary_timer, "timeout")
		primary_timer.stop()
	if secondary_fire_active and not primary_fire_active and secondary_timer.time_left == 0:
		fire_secondary()
		secondary_timer.start()
		yield(secondary_timer, "timeout")
		secondary_timer.stop()

func activate(fire_mode, event):
	var event_bool
	match event:
		"pressed": event_bool = true
		"released": event_bool = false
	match fire_mode:
		"primary": primary_fire_active = event_bool
		"secondary": secondary_fire_active = event_bool

func fire_primary():
	var projectile = actions[0].instance()
	projectile.damage = 20
	projectile.global_transform = $shoot_direction.global_transform
	projectile.direction = get_global_transform().basis.z
	get_node("/root/game/game_world/actors").add_child(projectile)
	
func fire_secondary():
	var projectile = actions[1].instance()
	projectile.damage = 50
	projectile.global_transform = $shoot_direction.global_transform
	projectile.direction = get_global_transform().basis.z
	get_node("/root/game/game_world/actors").add_child(projectile)