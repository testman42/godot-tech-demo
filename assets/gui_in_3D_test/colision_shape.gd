# very very ugly shortcut

extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func click(object):
	#print(object, " clicked on me")
	get_node("..").click(object)