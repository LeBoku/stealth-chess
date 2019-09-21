extends Node2D

const Board = preload("res://app/Board.gd")

onready var board: Board = get_board()

var selected_figure = null
func set_selected_figure(figure):
	if selected_figure:
		selected_figure.set_selected(false)
		selected_figure = null
		 
	selected_figure = figure

func _process(delta):
	if Input.is_action_just_pressed("next_turn"):
		process_enemy_turn()

func process_enemy_turn():
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Piece", "is_selectable", false)
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Enemy", "has_processed_turn", false)
	
	for piece in get_tree().get_nodes_in_group("Enemy"):
		piece.process_turn()
	
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Piece", "is_selectable", true)

func get_board():
	return get_tree().get_nodes_in_group("Board")[0]