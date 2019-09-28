extends TileMap

class_name Board

const Util = preload("res://app/Util.gd")
const CellContent = preload("res://app/Util/CellContent.gd")

func place_element(element: Node2D, cell:Vector2):
	element.position = Util.convert_to_position(cell)
	add_child(element)
	return element

func get_cell_content(position):
	var content_type = CellContent.CellType.Empty
	var piece: Node = null
	
	var tile_type = get_cell(position.x, position.y)

	if not(tile_type == 0 or tile_type == 1):
		content_type = CellContent.CellType.Obstacle
	else:
		piece = get_cell_piece(position)
	
	return CellContent.new(content_type, piece)
	
func get_cell_piece(position):
	for piece in get_all_pieces():
		if position == piece.get_cell():
			return piece
	
func get_all_pieces():
	return get_tree().get_nodes_in_group("Piece")

func is_same_cell(a, b):
	return Util.convert_to_cell(a) == Util.convert_to_cell(b)