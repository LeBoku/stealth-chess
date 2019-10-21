enum Figures { Pawn, Rook, Knight, Bishop, King, Queen }
enum AttentionStates { None, Suspicious, Alerted }
enum PieceAllegiance { Player, Enemy, Neutral }
enum PlayerActionTypes { Move, Attack, Stealth_Attack, Unknown }

const PLAYER_MOVE_HIGHLIGHT = "PLAYER_MOVE"
const ENEMY_MOVE_HIGHLIGHT = "ENEMY_MOVE"
const ENEMY_VIEW_HIGHLIGHT = "ENEMY_VIEW"

const RAD_15_DEG = PI/12
const RAD_30_DEG = PI/6
const RAD_45_DEG = PI/4

static func rotate_moves(moves):
	var rotated_moves = [] + moves
	
	for move in moves:
		rotated_moves.append(Vector2(move.y, -move.x))
		rotated_moves.append(Vector2(-move.y, move.x))
		rotated_moves.append(Vector2(-move.x, -move.y))
	
	return rotated_moves
	
static func is_between(target, start, end):
	return target > start and target < end
	
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
	
static func get_rounded_rotation(angle):
	return round(angle / RAD_45_DEG) *  RAD_45_DEG
	
class ByDistanceSorter:
	var _target: Vector2

	func sort_by_distance(moves: Array, target:Vector2):
		_target = target
		moves.sort_custom(self, "compare_distance")
		return moves

	func compare_distance(move1: Vector2, move2: Vector2):
		return (_target - move1).length() < (_target - move2).length()