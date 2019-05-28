extends Node2D

const Util = preload("res://app/Util.gd")

signal on_selected
signal on_deselected

export(Util.Figures) var type = Util.Figures.Pawn
export(bool) var is_friend = true

onready var manager = get_node("/root/Manager")
onready var movesets = get_node("/root/Movesets")
onready var display = $Display

onready var board = manager.get_board()

var can_jump: bool = false
var is_selected: bool = false
var is_selectable: bool = true

func _ready():
	can_jump = type == Util.Figures.Knight
	
	if is_friend:
		add_to_group("Friend")
	else:
		add_to_group("Enemy")

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