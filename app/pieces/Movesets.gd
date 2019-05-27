extends Node

const Util = preload("res://app/Util.gd")
const Board = preload("res://app/Board.gd")

var rook_moves = Util.rotate_moves(Util.get_steps_between(Vector2(0,0), Vector2(0,7)))
var bishop_moves = Util.rotate_moves(Util.get_steps_between(Vector2(0,0), Vector2(7,7)))

var move_sets = {
	Util.Figures.Pawn: [Vector2(0, -1), Vector2(0, -2)],
	Util.Figures.Rook: rook_moves,
	Util.Figures.Knight: Util.rotate_moves([Vector2(-1, 2), Vector2(1, 2)]),
	Util.Figures.Bishop: bishop_moves,
	Util.Figures.King: Util.rotate_moves([Vector2(1,1), Vector2(0,1)]),
	Util.Figures.Queen: rook_moves + bishop_moves
}

func get_moves(type, from: Vector2, board: Board):
	var moves = []
	
	for move in move_sets[type]:
		moves.append(move + from)
		
	if type == Util.Figures.Pawn:
		moves += get_special_pawn_moves(from, board)
	
	return moves
	
func get_special_pawn_moves(from: Vector2, board: Board):
	var specials = []
	
	for possibility in [from + Vector2(-1, -1), from + Vector2(1, -1)]:
		var cell_content = board.get_cell_content(possibility)
		if cell_content[1] != null and not cell_content[1].is_friend:
			specials.append(possibility)
		
	return specials