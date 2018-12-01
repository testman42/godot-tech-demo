extends Area

# for how long the AOE will be present in the game world, time in seconds, 0 means infinite duration
var duration_time = 0

# in what intervals does time in seconds, 0 means effect is applied only once
var interval_time = 0

# TODO: figure out how to apply multiple effects
var effects = {}

# is this AOE an intentional consequence of player's actions
# used to display hit marker
var is_player_attack = false

func _ready():
	start_timers()

func start_timers():
	if duration_time > 0:
		var duration_timer = Timer.new()
		duration_timer.wait_time = duration_time
		duration_timer.one_shot = true
		duration_timer.connect("timeout",self,"_on_duration_timer_timeout")
		add_child(duration_timer)
		duration_timer.start()
	if interval_time > 0:
		var interval_timer = Timer.new()
		interval_timer.wait_time = interval_time
		add_child(interval_timer)
		#interval_timer.connect("timeout",self,"_on_interval_timer_timeout")
		interval_timer.start()

func _on_body_entered(body):
	for effect in effects:
		if body.has_method("can_apply_effect") and body.can_apply_effect(effect):
			body.apply_effect(effect, effects[effect])
			if effect == "damage":
				get_node("/root/game/game_logic/main_loop/fps_logic").display_hit_marker(effects[effect][0])

func _on_duration_timer_timeout():
	queue_free()