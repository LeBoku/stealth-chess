extends Node

const Util = preload("res://app/Util.gd")
const Piece = preload("res://app/pieces/Piece.gd")
const PlayerMovePreview = preload("res://app/player-control/PlayerMovePreview.tscn")

onready var manager = get_node("/root/Manager")
onready var highlight_manager = get_node("/root/Manager/HighlightManager")

onready var board = manager.get_board()
onready var piece: Piece = get_parent()

func _ready():
	piece.allegiance = Util.PieceAllegiance.Player
	piece.add_to_group("Friend")
	piece.connect("on_selected", self, "display_player_options")
	piece.connect("on_deselected", self, "clear_highlights")
	piece.connect("on_death", self, "clear_highlights")

func display_player_options(piece):
	for move in piece.get_possible_moves(true):
		var cell_content = board.get_cell_content(move)
		var action_type
		var highlight = board.place_element(PlayerMovePreview.instance(), move)
		
		if cell_content.contains_enemy(piece):
			var enemy = cell_content.get_piece()
			if enemy.is_aware_of(piece):
				action_type = Util.PlayerActionTypes.Attack
			else:
				action_type = Util.PlayerActionTypes.Stealth_Attack
		else:
			action_type = Util.PlayerActionTypes.Move
	
		highlight.initialize(piece, action_type)
		highlight.connect("click", self, "on_highlight_selected", [action_type, move, cell_content])
		
func clear_highlights(piece):
	for h in get_tree().get_nodes_in_group(Util.PLAYER_MOVE_HIGHLIGHT):
		h.queue_free()
	
func on_highlight_selected(obj, action_type, target_cell, cell_content):
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
		
	manager.process_enemy_turn()
	
	if piece.is_selected:
		display_player_options(piece)