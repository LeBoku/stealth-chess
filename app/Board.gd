extends TileMap

const Highlight = preload("res://Highlight.tscn")
const Util = preload("res://Util.gd")

var selected_figure = null
var square_size = cell_size.x

func _on_figure_on_selected(figure):
	selected_figure = figure
	var moves = figure.get_possible_moves()
	for move in get_valid_moves(moves, figure):
		var h = Highlight.instance();
		add_child(h)
		h.position = convert_to_position(move)
		h.connect("highlight_selected", self, "_on_highlight_selected")
		
func _on_figure_on_deselected(figure):
	selected_figure = null
	var highlights = get_tree().get_nodes_in_group("Highlight")
	for h in highlights:
		h.queue_free()
		
func _on_highlight_selected(highlight):
	selected_figure.position = highlight.position

func convert_to_position(board_position):
	return Vector2(board_position.x * square_size + square_size/2, board_position.y * square_size + square_size/2)

func convert_to_board_position(position):
	return Vector2(floor(position.x / square_size), floor(position.y / square_size))

func is_same_board_position(a, b):
	return convert_to_board_position(a) == convert_to_board_position(b)

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
	var tile_type = get_cell(position.x, position.y)
	return tile_type == 0 or tile_type == 1