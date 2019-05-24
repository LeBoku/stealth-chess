extends TileMap

const Util = preload("res://Util.gd")
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
	var is_valid = true
	var friends = get_tree().get_nodes_in_group("Friend")
	var tile_type = get_cell(position.x, position.y)
	
	is_valid = tile_type == 0 or tile_type == 1
	
	for friend in friends:
		is_valid = is_valid and position != friend.get_board_position()
	
	return is_valid
	
func convert_to_position(board_position):
	return Vector2(board_position.x * square_size + square_size/2, board_position.y * square_size + square_size/2)

func convert_to_board_position(position):
	return Vector2(floor(position.x / square_size), floor(position.y / square_size))

func is_same_board_position(a, b):
	return convert_to_board_position(a) == convert_to_board_position(b)