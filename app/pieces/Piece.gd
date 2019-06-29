extends Node2D

const Util = preload("res://app/Util.gd")

signal on_selected
signal on_deselected
signal on_eaten

export(Util.Figures) var type = Util.Figures.Pawn
var is_friend = true

onready var manager = get_node("/root/Manager")
onready var movesets = get_node("/root/Movesets")
onready var display = $Display

onready var board = manager.get_board()

var is_selected: bool = false
var is_selectable: bool = true

func _ready():
	add_to_group("Piece")
	
	if is_friend:
		add_to_group("Friend")

func _input(event):
	if event is InputEventMouseButton and not event.pressed and is_selectable and is_over_piece(get_global_mouse_position()):
		set_selected( not is_selected)
	
func set_selected(state):
	is_selected = state

	if state:
		manager.set_selected_figure(self)
		emit_signal("on_selected" , self)

	else:
		emit_signal("on_deselected" , self)

func move_to(position):
	var cell_content = board.get_cell_content(board.convert_to_board_position(position))
	
	if cell_content[1] != null:
		cell_content[1].get_eaten()
	
	self.position = position

func get_eaten():
	emit_signal("on_eaten")
	queue_free()
	
func get_possible_moves():
	return movesets.get_moves(type, get_board_position(), board)

func get_board_position():
	return board.convert_to_board_position(self.global_position);

func is_over_piece(position):
	return get_board_position() == board.convert_to_board_position(position)