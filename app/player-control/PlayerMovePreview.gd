extends "res://app/BoardEntity.gd"

const action_sprites = {
	Util.PlayerActionTypes.Attack: preload("res://assets/attack.png"),
	Util.PlayerActionTypes.Stealth_Attack: preload("res://assets/stealth_attack.png"),
	Util.PlayerActionTypes.Move: preload("res://assets/direction.png"),
}

onready var display = $Display

var action_type = Util.PlayerActionTypes.Unknown

func _ready():
	add_to_group(Util.PLAYER_MOVE_HIGHLIGHT)
	
func initialize(player_piece, action_type):
	display.texture = action_sprites[action_type]
	var direction = get_cell() - player_piece.get_cell()
	set_rounded_rotation(direction.angle())