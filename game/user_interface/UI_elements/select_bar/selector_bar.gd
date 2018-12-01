extends Node2D

# "selector_bar" does not actually select anything, this is just an indicator of which item will be selected
# TODO: made data structure that is used to generate bar content
# TODO: make function that returns the selected item

export var number_of_groups = 5
export var direction = "up"

var current_group = 0
var currently_selected = 0


func _ready():
	match direction:
		"up": get_node("select_bar").grow_vertical = 0
		"down": get_node("select_bar").grow_vertical = 1
	
	for i in range(number_of_groups):
		var group_wrapper = VBoxContainer.new()
		group_wrapper.name = "group_wrapper"+str(i)
		# to keep line with category lables from jumping up and down when changing to a group wiht different number of items
		group_wrapper.rect_min_size = Vector2(0, 300) 
		var group_content = VBoxContainer.new()
		group_content.name = "group"+str(i)+"_content"
		var group_label = Label.new()
		group_label.text = "weapons"+str(i)
		if direction == "up": 
			group_wrapper.add_child(group_content)
			group_wrapper.alignment = 2
		group_wrapper.add_child(group_label)
		if direction == "down": 
			group_wrapper.add_child(group_content)
			group_wrapper.alignment = 0
		group_content.hide()
		get_node("select_bar").add_child(group_wrapper)
		
		# loltest
		# TODO: actually maybe fill up with the number of possible entried and then just hide/show as necesary
		# would be way less processor intensive than reconstructing tree every time selection happens
		var test = 0
		if test:
			randomize()
			for j in range(randi()%4+3):
				add_item_to_group("test"+str(j), i)
		
		#end of loltest
	populate_with_items()

# TODO: Deprecate this ASAP, make items have proper names themselves and let the bar be generated with those names
func populate_with_items():
	add_item_to_group("pistol", 1)
	add_item_to_group("plazma_rifle", 2)
	add_item_to_group("energy_rifle", 2)

# item is string
func show_item(item_name):
	var group_wrappers = get_node("select_bar").get_children()
	for group in len(group_wrappers):
		var group_content = get_node("select_bar/group_wrapper"+str(group)+"/group"+str(group)+"_content").get_children()
		for label in group_content:
			if label.text == item_name:
				label.show()

func add_item_to_group(item, group):
	# TODO: make this take more than just Label
	var label = Label.new()
	label.text = str(item)
	label.hide()
	var group_content = get_node("select_bar/group_wrapper"+str(group)+"/group"+str(group)+"_content")
	group_content.add_child(label)

func remove_item_from_group(item, group):
	pass

func hide_all_groups():
	var group_wrappers = get_node("select_bar").get_children()
	for i in len(group_wrappers):
		var items = group_wrappers[i].get_node("group"+str(i)+"_content").hide()#.get_children()
#		for item in items:
#			item.hide()

# step as in step forward or step back, 1 for forward, -1 for backwards
# TODO: make item selection way less sphagetti than it currently is
# TODO: make this actually generate from the state of inventory
# TODO: replace "step" with "position" and have character script handle the order
func cycle_selection(group, step=1):
	if group != current_group:
		hide_all_groups()
		current_group = group
		currently_selected = 0
	var group_content = get_node("select_bar/group_wrapper"+str(group)+"/group"+str(group)+"_content")
	group_content.show()
	var list = group_content.get_children()
	# if there are no items in group then don't do anything
	# this should only be case when testing
	if len(list) == 0: return 0
	#iterate through len because indexes
	list[currently_selected].uppercase = 1
	for i in len(list):
		if i != currently_selected:
			list[i].uppercase = 0
#		if i == currently_selected + step:
	currently_selected += step
	if currently_selected > len(list)-1:
		currently_selected = 0

func show_next_item_in_category(category):
	pass
