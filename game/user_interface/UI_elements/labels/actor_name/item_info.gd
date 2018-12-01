extends Node2D

onready var aim_ray = get_node("../../aim_ray")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	$text.text = str(aim_ray.get_collider())