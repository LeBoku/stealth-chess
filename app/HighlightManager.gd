extends Node

const Highlight = preload("res://Highlight.tscn")

onready var manager = get_node("/root/Manager")
onready var board = manager.get_board()

func add_highlight(move):
	var h = Highlight.instance();
	board.add_child(h)
	h.position = board.convert_to_position(move)
	h.connect("highlight_selected", manager, "_on_highlight_selected")
	
func clear_highlights():
	var highlights = get_tree().get_nodes_in_group("Highlight")
	for h in highlights:
		h.queue_free()
