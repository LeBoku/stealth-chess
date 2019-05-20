extends Camera2D

export(int) var move_margins = 100

func _process(delta):
	var mouse = get_viewport().get_mouse_position();
	var margins = get_viewport().get_visible_rect().grow(-move_margins)

	if not margins.has_point(mouse):
		var direction = mouse - ((margins.position + margins.end) / 2) 
		print(direction)
		self.position += direction.clamped(200) * delta