enum Figures { Pawn, Rook, Knight, Bishop, King, Queen }
enum CellType { Empty, Obstacle }
enum AttentionStates { None, Suspicious, Alerted}

const PLAYER_MOVE_HIGHLIGHT = "PLAYER_MOVE"
const ENEMY_MOVE_HIGHLIGHT = "ENEMY_MOVE"
const ENEMY_VIEW_HIGHLIGHT = "ENEMY_VIEW"

const RAD_15_DEG = PI/12
const RAD_30_DEG = PI/6
const RAD_45_DEG = PI/4

class CellData:
	var type
	var piece
	func _init(type, piece = null):
		self.type = type
		self.piece = piece
		
	func get_piece():
		return self.piece

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

static func round_to_cell(cell_ish: Vector2):
	return Vector2(round(cell_ish.x), round(cell_ish.y))
	
static func convert_to_position(cell):
	return Vector2(cell.x * 50 + 50/2, cell.y * 50 + 50/2)

static func convert_to_cell(position):
	return Vector2(floor(position.x / 50), floor(position.y / 50))