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
	piece.connect("on_selected", self, "on_piece_on_selected")
	piece.connect("on_deselected", self, "clear_highlights")
	piece.connect("on_eaten", self, "clear_highlights")

func on_piece_on_selected(piece):
	for move in piece.get_possible_moves(true):
		var highlight = board.place_element(PlayerMovePreview.instance(), move)
		
		highlight.initialize(piece)
		highlight.connect("click", self, "on_highlight_click")
		
func clear_highlights(piece):
	for h in get_tree().get_nodes_in_group(Util.PLAYER_MOVE_HIGHLIGHT):
		h.queue_free()
	
func on_highlight_click(highlight):
	var goal = highlight.get_cell()
	piece.set_selected(false)
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	piece.move_to(goal)
	manager.process_enemy_turn()
	
	if is_instance_valid(piece):
		piece.set_selected(true)