extends Node2D

func set_text(string):
	if string:
		show()
		$label.text = str(string)
	else:
		hide()