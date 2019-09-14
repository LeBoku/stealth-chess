extends Node

enum CellType { Empty, Obstacle }

var type
var piece

func _init(type, piece = null):
	self.type = type
	self.piece = piece
	
func get_piece():
	return self.piece
	
func is_walkable(for_piece, immediately=false):
	var is_occupied = false
	if immediately:
		is_occupied = piece != null and for_piece.is_ally(piece) \
				and (piece.has_processed_turn or len(piece.planned_path) == 0)
		
	return self.type == CellType.Empty and not is_occupied
	
func is_see_through():
	return self.type == CellType.Empty

func contains_ally(for_piece):
	return piece != null and for_piece.is_ally(piece)
	
func contains_enemy(for_piece):
	return piece != null and not for_piece.is_ally(piece)