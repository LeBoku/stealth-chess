extends Node2D

const Util = preload("res://app/Util.gd")

signal on_selected
signal on_deselected
signal on_eaten
signal on_turn

export(Util.Figures) var type = Util.Figures.Pawn
var is_friend = true

onready var manager = get_node("/root/Manager")
onready var movesets = get_node("/root/Movesets")
onready var pathfinder = get_node("/root/Pathfinder")
onready var display = $Display
onready var pathPreviewManager = $PathPreviewManager

onready var board = manager.get_board()

var planned_path = []

var is_selected: bool = false
var is_selectable: bool = true

func _ready():
	add_to_group("Piece")
	
	if is_friend:
		add_to_group("Friend")

func process_turn():
	if len(planned_path):
		move_to(planned_path.pop_front())
		
	emit_signal("on_turn")

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

func set_planned_path_to(goal):
	var goal_position = board.convert_to_cell(goal)
	planned_path = pathfinder.get_shortest_path(get_cell(), goal_position, type)
	
	if planned_path == null:
		planned_path = []
		
	pathPreviewManager.show_preview(planned_path)
	
func move_to(position):
	var cell_content = board.get_cell_content(position)
	
	if cell_content[1] != null:
		cell_content[1].get_eaten()
	
	self.position = board.convert_to_position(position)

func get_eaten():
	emit_signal("on_eaten")
	queue_free()
	
func get_possible_moves():
	return movesets.get_moves(type, get_cell(), board)

func get_cell():
	return board.convert_to_cell(self.global_position);

func is_over_piece(position):
	return get_cell() == board.convert_to_cell(position)