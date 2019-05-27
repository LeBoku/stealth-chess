extends Sprite

const Util = preload("res://app/Util.gd")

signal on_selected
signal on_deselected

export (Util.Figures) var type = Util.Figures.Pawn
export(bool) var can_jump = false
export(bool) var is_selectable = true

var is_selected = false

onready var manager = get_node("/root/Manager")
onready var board = manager.get_board()
onready var is_friend = is_in_group("Friend")

onready var movesets = get_node("/root/Movesets")

func _input(event):
	if event is InputEventMouseButton and not event.pressed and is_selectable and is_over_piece(get_global_mouse_position()):
		if not is_selected:
			is_selected = true
			emit_signal("on_selected" , self)

		else:
			is_selected = false
			emit_signal("on_deselected" , self)
	
func get_possible_moves():
	return movesets.get_moves(type, get_board_position(), board)

func get_board_position():
	return board.convert_to_board_position(self.position);

func is_over_piece(position):
	return get_board_position() == board.convert_to_board_position(position)