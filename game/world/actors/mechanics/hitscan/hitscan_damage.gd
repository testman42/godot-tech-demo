extends RayCast

export var damage = 10
export var hitscan_range = 40
export var damage_type = "normal"

func _ready():
	cast_to = Vector3(0,0,hitscan_range)
	set_process(true)

func _process(delta):
	var collider = get_collider()
	if collider and collider.has_method("get_hit"):
		collider.get_hit(damage, damage_type)
		
		# quick workaround: tell crosshair to display hit marker if collider can be damaged,
		# even if we are not the ones applying damage
		if collider.has_method("take_damage"):
			get_node("/root/game/game_logic/main_loop/fps_logic").display_hit_marker(damage)
	free()