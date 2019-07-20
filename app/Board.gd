extends TileMap

const Util = preload("res://app/Util.gd")
var square_size = cell_size.x

func place_element(element: Node2D, cell:Vector2):
	element.position = convert_to_position(cell)
	add_child(element)

func get_cell_content(position):
	var content_type = Util.CellContent.Empty
	var piece: Node = null
	
	var tile_type = get_cell(position.x, position.y)

	if not(tile_type == 0 or tile_type == 1):
		content_type = Util.CellContent.Obstacle
	else:
		piece = get_cell_piece(position)
	
	return [content_type, piece]
	
func get_cell_piece(position):
	for piece in get_all_pieces():
		if position == piece.get_cell():
			return piece
	
func get_all_pieces():
	return get_tree().get_nodes_in_group("Piece")
	
func convert_to_position(cell):
	return Vector2(cell.x * square_size + square_size/2, cell.y * square_size + square_size/2)

func convert_to_cell(position):
	return Vector2(floor(position.x / square_size), floor(position.y / square_size))

func is_same_cell(a, b):
	return convert_to_cell(a) == convert_to_cell(b)