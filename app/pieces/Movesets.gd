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

func get_moves(type, from: Vector2, board: Board, max_distance: int = 8):
	var moves = []
	
	if type == Util.Figures.Pawn:
		max_distance = min(max_distance, 2)
	elif type == Util.Figures.Knight or type == Util.Figures.King:
		max_distance = min(max_distance, 1)
	
	for move in move_sets[type]:
		for distance in range(0, max_distance):
			var step = move * (distance + 1) + from
			if is_cell_valid(step, board):
				moves.append(step)
			else:
				break

	if type == Util.Figures.Pawn:
		moves += get_special_pawn_moves(from, board)
	
	return moves

func is_cell_valid(position, board):
	var cell_content = board.get_cell_content(position)
	var type = cell_content[0]
	var piece = cell_content[1]
	
	return type == Util.CellContent.Empty

func get_special_pawn_moves(from: Vector2, board: Board):
	var specials = []
	
	for possibility in [from + Vector2(-1, -1), from + Vector2(1, -1)]:
		var cell_content = board.get_cell_content(possibility)
		if cell_content[1] != null and not cell_content[1].is_friend:
			specials.append(possibility)
		
	return specials