extends Node

const Util = preload("res://Util.gd")

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

func get_moves(type, from):
	var moves = []
	
	for move in move_sets[type]:
		moves.append(move + from)
	
	return moves