enum Figures { Pawn, Rook, Knight, Bishop, King, Queen }
enum CellContent { Empty, Obstacle }
enum AttentionStates { None, Suspicious, Alerted}

const PLAYER_MOVE_HIGHLIGHT = "PLAYER_MOVE"
const ENEMY_MOVE_HIGHLIGHT = "ENEMY_MOVE"

static func rotate_moves(moves):
	var rotated_moves = [] + moves
	
	for move in moves:
		rotated_moves.append(Vector2(move.y, -move.x))
		rotated_moves.append(Vector2(-move.y, move.x))
		rotated_moves.append(Vector2(-move.x, -move.y))
	
	return rotated_moves
	
static func slice(array: Array, from:int, to = null):
	if to == null or to > len(array):
		to = len(array)

	var slice = []
	
	for i in range(from, to):
		slice.append(array[i])
	
	return slice