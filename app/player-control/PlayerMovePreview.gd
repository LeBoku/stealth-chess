extends "res://app/BoardEntity.gd"

func _ready():
	add_to_group(Util.PLAYER_MOVE_HIGHLIGHT)
	
func initialize(player_piece):
	var move_direction = get_cell() - player_piece.get_cell()
	set_rounded_rotation(move_direction.angle())