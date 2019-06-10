enum Figures { Pawn, Rook, Knight, Bishop, King, Queen }
enum CellContent { Empty, Obstacle }
enum AttentionStates { None, Suspicious, Alerted}

static func get_steps_between(start_position, end_position):
	var steps = []
	var current_step = start_position
	
	var direction = (end_position - start_position).normalized()
	direction.x = round(direction.x)
	direction.y = round(direction.y)
	
	while current_step.distance_to(end_position) > 0:
		current_step = current_step + direction
		steps.append(current_step)

	return steps

static func rotate_moves(moves):
	var rotated_moves = [] + moves
	
	for move in moves:
		rotated_moves.append(Vector2(move.y, -move.x))
		rotated_moves.append(Vector2(-move.y, move.x))
		rotated_moves.append(Vector2(-move.x, -move.y))
	
	return rotated_moves