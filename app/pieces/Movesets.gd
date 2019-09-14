extends Node

const Util = preload("res://app/Util.gd")
const Board = preload("res://app/Board.gd")

var straight_moves = Util.rotate_moves([Vector2(0,1)])
var diagonal_moves = Util.rotate_moves([Vector2(1,1)])
var omnidirectional_moves = straight_moves + diagonal_moves

var move_sets = {
	Util.Figures.Pawn: [Vector2(0, -1)],
	Util.Figures.Rook: straight_moves,
	Util.Figures.Knight: Util.rotate_moves([Vector2(-1, 2), Vector2(1, 2)]),
	Util.Figures.Bishop: diagonal_moves,
	Util.Figures.King: omnidirectional_moves,
	Util.Figures.Queen: omnidirectional_moves
}

func get_moves(piece, from: Vector2, board: Board, immediatly = false, max_distance: int = 1):
	var moves = []
	
	if max_distance == 0 and piece.type == Util.Figures.Pawn:
		max_distance = 2
	
	for move in move_sets[piece.type]:
		for distance in range(0, max_distance):
			var step = move * (distance + 1) + from
			if is_cell_valid(step, board, piece, immediatly):
				moves.append(step)
			else:
				break

	if piece.type == Util.Figures.Pawn:
		moves += get_special_pawn_moves(piece, from, board)
	
	return moves

func is_cell_valid(position, board, piece, immediatly = false):
	var cell_content = board.get_cell_content(position)
	return cell_content.is_walkable(piece, immediatly)

func get_special_pawn_moves(piece, from: Vector2, board: Board):
	var specials = []
	
	for possibility in [from + Vector2(-1, -1), from + Vector2(1, -1)]:
		if board.get_cell_content(possibility).contains_enemy(piece):
			specials.append(possibility)
		
	return specials