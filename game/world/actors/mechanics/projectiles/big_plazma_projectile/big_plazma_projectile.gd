extends "res://game/world/actors/mechanics/projectiles/projectile.gd"

func _ready():
	velocity = 40
	damage = 50

func get_hit(damage, damage_type="normal"):
	if damage_type == "laser":
		explode()

# TODO: this is a very bad way to implement AOE damage. Need to implement proper explosion mechanic and have it be spawned here.
func explode():
	var plazma_explosion_scene = load("res://game/world/actors/mechanics/area_of_effect/plazma_explosion/plazma_explosion.tscn")
	var plazma_explosion = plazma_explosion_scene.instance()
	plazma_explosion.global_transform = self.global_transform
	get_node("/root/game/game_world/actors").add_child(plazma_explosion)
	queue_free()
	
func hit():
	pass
	#explode()