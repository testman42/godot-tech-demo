extends Control

var autostart = 1

# TODO: IMPORTANT: find out why UI elements act as if they are in front of menu, even though menu is displayed above them
# this prevents clicking onparts of menu buttons, which can in worst case result in player being stuck in the menu
func _ready():
	if autostart:
		_on_play_button_pressed()
		show_on_top = true

func _on_play_button_pressed():
	get_tree().change_scene("res://game/game.tscn")

func _on_settings_button_pressed():
	#TODO: make settings window appear
	pass

func _on_exit_button_pressed():
	get_tree().quit()