extends Node2D

const Board = preload("res://app/Board.gd")

onready var board: Board = get_board()

var selected_figure = null
func set_selected_figure(figure):
	if selected_figure:
		selected_figure.set_selected(false)
		
	selected_figure = figure

func process_enemy_turn():
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Friend", "is_selectable", false)
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.process_turn()
	
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Friend", "is_selectable", true)

func get_board():
	return get_tree().get_nodes_in_group("Board")[0]