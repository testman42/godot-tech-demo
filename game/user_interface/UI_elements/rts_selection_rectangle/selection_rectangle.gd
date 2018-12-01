extends Node2D


export var draw = 0
var rect_color = Color(1,1,1) # as white as it gets
var rectangle_corners = []

func _process(delta):
	update()

func _draw():
	if draw:
		draw_line( rectangle_corners[0], rectangle_corners[1], rect_color )
		draw_line( rectangle_corners[1], rectangle_corners[2], rect_color )
		draw_line( rectangle_corners[2], rectangle_corners[3], rect_color )
		draw_line( rectangle_corners[3], rectangle_corners[0], rect_color )
	
func draw_rect(start_corner,end_corner):
	rectangle_corners.append(start_corner)
	rectangle_corners.append(Vector2(start_corner.x, end_corner.y))
	rectangle_corners.append(end_corner)
	rectangle_corners.append(Vector2(end_corner.x, start_corner.y))

# TODO: check if new code works, then remove this legacy code
#	corner1 = start_corner
#	corner2 = Vector2(start_corner.x, end_corner.y)
#	corner3 = end_corner
#	corner4 = Vector2(end_corner.x, start_corner.y)
	draw = 1
	set_process(true)

func hide_rect():
	draw = 0