extends Node
signal on_selected
signal on_deselected

var is_selected = false
var is_selectable = true

onready var board = get_node("/root/Board")
var piece_moves = rotate_moves([Vector2(0, 1), Vector2(0, 2)])

func _input(event):
	if event is InputEventMouseButton and not event.pressed and is_over_piece(event.position) and is_selectable:
		if not is_selected:
			is_selected = true
			emit_signal("on_selected" , self)
		else:
			is_selected = false
			emit_signal("on_deselected" , self)
	
func get_possible_moves():
	var moves = []
	
	for move in piece_moves:
		moves.append(board.convert_to_board_position(self.position) + move)
	
	return moves
	
func rotate_moves(moves):
	var rotated_moves = [] + moves
	
	for move in moves:
		rotated_moves.append(Vector2(move.y, -move.x))
		rotated_moves.append(Vector2(-move.y, move.x))
		rotated_moves.append(Vector2(-move.x, -move.y))
	
	return rotated_moves

func is_over_piece(position):
	return board.convert_to_board_position(self.position) == board.convert_to_board_position(position)