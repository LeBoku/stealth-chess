extends Node

const Util = preload("res://app/Util.gd")
const Board = preload("res://app/Board.gd")

var possible_moves = Util.rotate_moves([Vector2(1,1)]) + Util.rotate_moves([Vector2(0,1)])

func get_moves(piece, from: Vector2, board: Board, immediatly = false):
	var moves = []
	
	for move in possible_moves:
		var step = move + from
		if is_cell_valid(step, board, piece, immediatly):
			moves.append(step)
	
	return moves

func is_cell_valid(position, board, piece, immediatly = false):
	var cell_content = board.get_cell_content(position)
	return cell_content.is_walkable(piece, immediatly)