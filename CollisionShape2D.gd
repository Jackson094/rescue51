tool
extends CollisionShape2D

export (Color) var color = Color(1,1,1,1) setget set_color

func set_color(new_color):
	color = new_color
	update()
	
func _draw():
	var offset_position = Vector2(0,0)
	if shape is CircleShape2D:
		draw_circle(offset_position, shape.radius, color)
	elif shape is RectangleShape2D:
		var rect = Rect2(offset_position - shape.extents, shape.extents* 2.0)
		draw_rect(rect, color)
