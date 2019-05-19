extends Node
signal on_selected
signal on_deselected

var is_selected = false
var is_selectable = true

onready var board = get_node("/root/Board")
onready var moveset = $Moveset
var can_jump = false

func _input(event):
	if event is InputEventMouseButton and not event.pressed and is_selectable and board.is_same_board_position(self.position, event.position):
		if not is_selected:
			is_selected = true
			emit_signal("on_selected" , self)

		else:
			is_selected = false
			emit_signal("on_deselected" , self)
	
func get_possible_moves():
	return moveset.get_moves(get_board_position())

func get_board_position():
	return board.convert_to_board_position(self.position);

func is_over_piece(position):
	return get_board_position() == board.convert_to_board_position(position)