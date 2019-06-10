extends Node

const Util = preload("res://app/Util.gd")

onready var movesets = get_node("/root/Movesets")
onready var manager = get_node("/root/Manager")
onready var board = manager.get_board()

var sorter = ByDistanceSorter.new()

func get_shortest_path(from: Vector2, to: Vector2, figure_type, _happend_steps = [], shortest_path = null):
	var moves = movesets.get_moves(figure_type, from, board)
	moves = remove_tried_steps(_happend_steps, moves)
	moves = sorter.sort_by_distance(moves, to)
	
	for move in moves:
		var current_path = _happend_steps.duplicate()
		current_path.append(move)
		
		if is_shorter_path(current_path, shortest_path):
			if move == to:
				return current_path
			else:
				var path = get_shortest_path(move, to, figure_type, current_path, shortest_path)
				if path:
					return path

	return null

func is_shorter_path(path, shortest_path):
	if shortest_path == null:
		return true
	else: 
		var length_diff = get_path_length(shortest_path) - get_path_length(path)
		return length_diff > 0 or (length_diff == 0 and shortest_path.size() > path.size())

func get_path_length(path):
	var length = 0
	var previous_step = null
	
	for step in path:
		if previous_step != null:
			length += (previous_step - step).length()
		
		previous_step = step
		
	return length

func remove_tried_steps(happend_steps, moves):
	var valid_moves = []
	
	for move in moves:
		var valid = true
		
		for happend in happend_steps:
			if happend == move:
				valid = false
				break
	
		if valid:
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