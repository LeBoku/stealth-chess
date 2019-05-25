extends Node2D

const Board = preload("res://app/Board.gd")
const AI = preload("res://app/pieces/AI.gd")

onready var board: Board = get_board()
onready var highlight_manager = $HighlightManager

var selected_figure = null

func _ready():
	for friend in get_tree().get_nodes_in_group("Friend"):
		friend.connect("on_selected", self, "_on_figure_on_selected")
		friend.connect("on_deselected", self, "_on_figure_on_deselected")

func _on_figure_on_selected(figure):
	if selected_figure != null:
		deselect_figure()

	selected_figure = figure
	var moves = figure.get_possible_moves()
	for move in board.get_valid_moves(moves, figure):
		highlight_manager.add_highlight(move)
		
func _on_figure_on_deselected(figure):
	deselect_figure()

func _on_highlight_selected(highlight):
	var cell_content = board.get_cell_content(board.convert_to_board_position(highlight.position))
	
	if cell_content[1] != null:
		cell_content[1].queue_free()
	
	selected_figure.position = highlight.position
	
	
	process_enemy_turn()

func deselect_figure():
	selected_figure.is_selected = false
	selected_figure = null

	highlight_manager.clear_highlights()

func process_enemy_turn():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		for node in enemy.get_children():
			if node is AI:
				node.process_turn()

func get_board():
	return get_tree().get_nodes_in_group("Board")[0]