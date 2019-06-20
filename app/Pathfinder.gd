extends Node

const Util = preload("res://app/Util.gd")

onready var movesets = get_node("/root/Movesets")
onready var manager = get_node("/root/Manager")
onready var board = manager.get_board()

var sorter = ByDistanceSorter.new()

func get_shortest_path(from: Vector2, to: Vector2, figure_type, _happend_steps = [], shortest_path = null):
	var moves = movesets.get_moves(figure_type, from, board, 1)
	moves = remove_tried_steps(_happend_steps, shortest_path, moves)
	moves = sorter.sort_by_distance(moves, to)
	
	for move in moves:
		var current_path = _happend_steps.duplicate()
		current_path.append(move)
		
		if shortest_path != null:
			if move in shortest_path:
				var i_in_shortest = shortest_path.find(move)
				var i_in_current = current_path.find(move)
	
				if i_in_shortest > i_in_current:
					shortest_path = current_path + Util.slice(shortest_path, i_in_shortest)
				else:
					break
		
			if (to - move).length() > len(shortest_path):
				break
		
		if is_shorter_path(current_path, shortest_path):
			if move == to:
				shortest_path = current_path
			else:
				shortest_path = get_shortest_path(move, to, figure_type, current_path, shortest_path)

	return shortest_path

func is_shorter_path(path, shortest_path):
	return shortest_path == null or len(shortest_path) - len(path) > 0

func remove_tried_steps(happend_steps, shortest_path, moves):
	var valid_moves = []
	
	for move in moves:
		if not move in happend_steps:
			valid_moves.append(move)
			
	return valid_moves

class ByDistanceSorter:
	var _target: Vector2

	func sort_by_distance(moves: Array, target:Vector2):
		_target = target
		moves.sort_custom(self, "compare_distance")
		return moves

	func compare_distance(move1: Vector2, move2: Vector2):
		return (_target - move1).length() < (_target - move2).length()