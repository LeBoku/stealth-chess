extends Node

enum CellType { Empty, Obstacle }

var type
var piece

func _init(type, piece = null):
	self.type = type
	self.piece = piece
	
func get_piece():
	return self.piece
	
func is_walkable(piece):
	return self.type == CellType.Empty and (self.piece == null or (self.piece.is_friend and piece.is_friend))
	
func is_see_through():
	return self.type == CellType.Empty

func contains_enemy():
	return self.piece != null and not self.piece.is_friend