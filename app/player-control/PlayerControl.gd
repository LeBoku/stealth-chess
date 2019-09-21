extends Node

const Util = preload("res://app/Util.gd")
const Piece = preload("res://app/pieces/Piece.gd")

onready var manager = get_node("/root/Manager")
onready var highlight_manager = get_node("/root/Manager/HighlightManager")

onready var piece: Piece = get_parent()

func _ready():
	piece.allegiance = Util.PieceAllegiance.Player
	piece.add_to_group("Friend")
	piece.connect("on_selected", self, "on_figure_on_selected")
	piece.connect("on_deselected", self, "clear_highlights")
	piece.connect("on_eaten", self, "clear_highlights")

func on_figure_on_selected(figure):
	for move in figure.get_possible_moves(true):
		var highlight = highlight_manager.add_highlight(move, Util.PLAYER_MOVE_HIGHLIGHT)
		highlight.connect("click", self, "on_highlight_click")
		
func clear_highlights(figure):
	highlight_manager.clear_highlights(Util.PLAYER_MOVE_HIGHLIGHT)
	
func on_highlight_click(highlight):
	var goal = highlight.get_cell()
	piece.set_selected(false)
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	piece.move_to(goal)
	manager.process_enemy_turn()
	
	if is_instance_valid(piece):
		piece.set_selected(true)