extends Node

const Highlight = preload("res://app/highlight/Highlight.tscn")

onready var manager = get_node("/root/Manager")
onready var board = manager.get_board()

func add_highlight(cell: Vector2, type = "Undefined"):
	var h = Highlight.instance();
	h.add_to_group(type)
	board.place_element(h, cell)
	return h
	
func clear_highlights(type = "Undefined"):
	var highlights = get_tree().get_nodes_in_group(type)
	for h in highlights:
		h.queue_free()
