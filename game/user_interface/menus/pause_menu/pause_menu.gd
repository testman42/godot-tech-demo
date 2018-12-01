
# has to be Node2D instead of Control so that it can have Z Index set to more than UI Layer, so that UI elements don't overlap the menu

#extends Control
extends Node2D

onready var main_loop = get_node("/root/game/game_logic/main_loop")

func _on_resume_button_pressed():
	main_loop.resume_game()
	queue_free()

func _on_settings_button_pressed():
	pass

func _on_main_menu_button_pressed():
	get_tree().change_scene("res://game/user_interface/menus/main_menu/main_menu.tscn")

func _on_exit_button_pressed():
	# TODO: implement state saving for the things that need to be saved
	get_tree().quit()
