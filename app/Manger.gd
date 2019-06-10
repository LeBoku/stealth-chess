extends Node2D

const Board = preload("res://app/Board.gd")

const PLAYER_MOVE_HIGHLIGHT = "PLAYER_MOVE"
const ENEMY_MOVE_HIGHLIGHT = "ENEMY_MOVE"

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
	
	for move in figure.get_possible_moves():
		highlight_manager.add_highlight(move, PLAYER_MOVE_HIGHLIGHT)
		
func _on_figure_on_deselected(figure):
	deselect_figure()

func _on_highlight_selected(highlight):
	var cell_content = board.get_cell_content(board.convert_to_board_position(highlight.position))
	
	if cell_content[1] != null:
		cell_content[1].get_eaten()
	
	selected_figure.position = highlight.position
	
	process_enemy_turn()

func deselect_figure():
	selected_figure.is_selected = false
	selected_figure = null

	highlight_manager.clear_highlights(PLAYER_MOVE_HIGHLIGHT)

func process_enemy_turn():
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Friend", "is_selectable", false)
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.process_turn()
	
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Friend", "is_selectable", true)

func get_board():
	return get_tree().get_nodes_in_group("Board")[0]