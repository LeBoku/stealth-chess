extends Node2D

const Util = preload("res://app/Util.gd")

signal hover_enter
signal hover_leave

signal click

var is_hovered = false

func _input(event):
	if event is InputEventMouseButton and not event.pressed and is_over_piece(get_global_mouse_position()):
		emit_signal("click", self)
	
	elif event is InputEventMouseMotion:
		if not is_hovered and is_over_piece(get_global_mouse_position()):
			emit_signal("hover_enter", self)
			is_hovered = true
			
		elif is_hovered and not is_over_piece(get_global_mouse_position()):
			emit_signal("hover_leave", self)
			is_hovered = false

func get_cell():
	return Util.convert_to_cell(self.global_position);

func is_over_piece(position):
	return get_cell() == Util.convert_to_cell(position)