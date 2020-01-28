extends "res://game/world/actors/objects/weapons/weapon.gd"

var actions = []
var already_affected_actors = []
var swing_active = false
var block_active = false
var swing_timer = Timer.new()
var damage_timer = Timer.new()
var damage_check_time = 0.2
var damage = 20

func _ready():
	swing_timer.wait_time = damage_check_time
	swing_timer.one_shot = false

func _process(delta):
	if swing_active: # and swing_timer.time_left == 0:
		swing()

func activate(fire_mode, event="pressed"):
	var event_bool
	match event:
		"pressed": event_bool = true
		"released": event_bool = false
	match fire_mode:
		"primary": swing_active = event_bool
		"secondary": block_active = event_bool

# TODO: figure out why player can commit sudoku
func swing():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("swing")
	var currently_hitting = $damage_area.get_overlapping_bodies()
	for actor in currently_hitting:
		if actor.has_method("get_hit") and not actor in already_affected_actors:
			actor.get_hit(damage)
			already_affected_actors.append(actor)
			if actor.has_method("take_damage"):
				get_node("/root/game/game_logic/main_loop/fps_logic").display_hit_marker(damage)
	already_affected_actors.clear()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	rotation.x = 0
	swing_active = false
