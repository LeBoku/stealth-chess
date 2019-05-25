extends TileMap

const Util = preload("res://app/Util.gd")
var square_size = cell_size.x

func get_valid_moves(moves, figure):
	var valid_moves = []
	var start_position = figure.get_board_position()
	
	for move in moves:
		var is_valid_move = true
		
		if not figure.can_jump:
			for step in Util.get_steps_between(start_position, move):
				if not is_cell_valid(step):
					is_valid_move = false
					break
			
		else:
			is_valid_move = is_cell_valid(move)
			
		if is_valid_move:
			valid_moves.append(move)
			
	return valid_moves
	
func is_cell_valid(position):
	var cell_content = get_cell_content(position)
	var type = cell_content[0]
	var piece = cell_content[1]
	
	return type == Util.CellContent.Empty and (piece == null or not piece.is_friend)
	
func get_cell_content(position):
	var content_type = Util.CellContent.Empty
	var piece: Node = null
	
	var tile_type = get_cell(position.x, position.y)

	if not(tile_type == 0 or tile_type == 1):
		content_type = Util.CellContent.Obstacle
	else:
		piece = get_cell_piece(position)
	
	return [content_type, piece]
	
func get_cell_piece(position):
	for piece in get_all_pieces():
		if position == piece.get_board_position():
			return piece
	
func get_all_pieces():
	return get_tree().get_nodes_in_group("Friend") + get_tree().get_nodes_in_group("Enemy") 
	
func convert_to_position(board_position):
	return Vector2(board_position.x * square_size + square_size/2, board_position.y * square_size + square_size/2)

func convert_to_board_position(position):
	return Vector2(floor(position.x / square_size), floor(position.y / square_size))

func is_same_board_position(a, b):
	return convert_to_board_position(a) == convert_to_board_position(b)