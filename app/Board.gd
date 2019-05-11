extends Node2D

var Highlight = preload("res://Highlight.tscn")

var square_size = 40
onready var squares = $TileMap

func _ready():
	square_size = squares.cell_size.x

func _on_figure_on_selected(figure):
	var moves = figure.get_possible_moves()
	for move in get_valid_moves(moves):
		var h = Highlight.instance();
		add_child(h)
		h.position = convert_to_position(move)
		
func _on_figure_on_deselected(figure):
	var highlights = get_tree().get_nodes_in_group("Highlight")
	for h in highlights:
		remove_child(h)

func convert_to_position(board_position):
	return Vector2(board_position.x * square_size + square_size/2, board_position.y * square_size + square_size/2)

func convert_to_board_position(position):
	return Vector2(floor(position.x / square_size), floor(position.y / square_size))

func is_same_board_position(a, b):
	return convert_to_board_position(a) == convert_to_board_position(b)

func get_valid_moves(moves):
	var valid_moves = []
	for move in moves:
		if 0 <= move.x and move.x < 8 and 0 <= move.y and move.y < 8:
			valid_moves.append(move)
			
	return valid_moves