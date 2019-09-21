extends Node2D

const Board = preload("res://app/Board.gd")

onready var board: Board = get_board()

var selected_piece = null
func set_selected_piece(piece):
	if selected_piece:
		selected_piece.set_selected(false)
		selected_piece = null
		 
	selected_piece = piece

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