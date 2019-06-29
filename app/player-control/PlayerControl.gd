extends Node

const Util = preload("res://app/Util.gd")
const Piece = preload("res://app/pieces/Piece.gd")

onready var manager = get_node("/root/Manager")
onready var highlight_manager = get_node("/root/Manager/HighlightManager")

onready var piece: Piece = get_parent()

func _ready():
	piece.connect("on_selected", self, "_on_figure_on_selected")
	piece.connect("on_deselected", self, "_on_figure_on_deselected")

func _on_figure_on_selected(figure):
	for move in figure.get_possible_moves():
		var highlight = highlight_manager.add_highlight(move, Util.PLAYER_MOVE_HIGHLIGHT)
		highlight.connect("highlight_selected", self, "_on_highlight_selected")
		
func _on_figure_on_deselected(figure):
	highlight_manager.clear_highlights(Util.PLAYER_MOVE_HIGHLIGHT)
	
func _on_highlight_selected(highlight):
	piece.move_to(highlight.position)
	piece.set_selected(false)