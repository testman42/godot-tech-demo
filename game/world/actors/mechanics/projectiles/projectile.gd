extends KinematicBody

export var velocity = 1
export var damage = 1
export var direction = Vector3()

func _ready():
	pass

func _process(delta):
	move(delta)
	
func move(delta):
	var hit = move_and_collide(direction*velocity*delta)
	if hit:
		hit()
		#print(hit.collider.name)
		if hit.collider.has_method("get_hit"):
			hit.collider.get_hit(damage)
			if hit.collider.has_method("take_damage"):
				get_node("/root/game/game_logic/main_loop/fps_logic").display_hit_marker(damage)
		queue_free()

# can be used to spawn other scene on collision
func hit():
	pass