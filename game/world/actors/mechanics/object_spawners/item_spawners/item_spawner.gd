extends Spatial

# variable that determines if item is already spawned
export var item_already_spawned = 0

# respawn time in seconds
export var respawn_time = 10

# countdown display mode
# TODO: implement "none" to disable countdown
export var display_mode = "text"

var item_nodepath

# not _ready, because we want this to be ran on scene that inherits it
func _on_ready():
	$respawn_timer.wait_time = respawn_time
	if not item_already_spawned and item_nodepath:
		spawn_item()
	else:
		print("starting timer")
		start_timer()

func start_timer():
	$respawn_timer.start()
	
func spawn_item():
	var node = load(item_nodepath)
	var instance = node.instance()
	add_child(instance)
	item_already_spawned = 1

func item_taken():
	item_already_spawned = 0
	start_timer()

func _on_respawn_timer_timeout():
	spawn_item()
	
