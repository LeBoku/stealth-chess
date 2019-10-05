extends Node

signal player_turn_start
signal player_turn_end

const Util = preload("res://app/Util.gd")
const Piece = preload("res://app/pieces/Piece.gd")
const PlayerMovePreview = preload("res://app/player-control/PlayerMovePreview.tscn")

onready var manager = get_node("/root/Manager")
onready var movesets = get_node("/root/Movesets")

onready var board = manager.get_board()
onready var piece: Piece = get_parent()

var selected_piece = null
var player_pieces = []

func start_turn(pieces):
	player_pieces = pieces
	
	for piece in player_pieces:
		piece.connect("click", self, "on_piece_click")
	
	emit_signal("player_turn_start")
	if is_instance_valid(selected_piece):
		display_player_options(selected_piece)
	
func end_turn():
	for piece in player_pieces:
		piece.disconnect("click", self, "on_piece_click")

	emit_signal("player_turn_end")

func on_piece_click(piece):
	if selected_piece != null:
		clear_highlights(piece)
	
	if piece != selected_piece:
		display_player_options(piece)
		selected_piece = piece
	else:
		selected_piece = null

func display_player_options(piece):
	for move in movesets.get_moves(piece, piece.get_cell(), board, true):
		var cell_content = board.get_cell_content(move)
		var action_type = Util.PlayerActionTypes.Unknown
		
		if cell_content.contains_enemy(piece):
			var enemy = cell_content.get_piece()
			if enemy.is_aware_of(piece):
				action_type = Util.PlayerActionTypes.Attack
			else:
				action_type = Util.PlayerActionTypes.Stealth_Attack
		else:
			action_type = Util.PlayerActionTypes.Move
	
		var highlight = board.place_element(PlayerMovePreview.instance(), move)
		highlight.initialize(piece, action_type)
		highlight.connect("click", self, "on_highlight_selected", [piece, action_type, move, cell_content])
		
func clear_highlights(piece):
	for h in get_tree().get_nodes_in_group(Util.PLAYER_MOVE_HIGHLIGHT):
		h.queue_free()
	
func on_highlight_selected(obj, piece, action_type, target_cell, cell_content):
	clear_highlights(piece)
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	if action_type == Util.PlayerActionTypes.Stealth_Attack:
		var target_piece = cell_content.get_piece()
		target_piece.get_attacked(target_piece.health)
		
	elif action_type == Util.PlayerActionTypes.Attack:
		var target_piece = cell_content.get_piece()
		
		piece.attack(target_piece)
	elif action_type == Util.PlayerActionTypes.Move:
		piece.move_to(target_cell)

	end_turn()