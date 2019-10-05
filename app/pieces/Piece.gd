extends "res://app/BoardEntity.gd"

signal on_selected
signal on_deselected
signal on_death
signal on_turn
signal reached_path_end

export(Util.Figures) var type = Util.Figures.Pawn
export(Util.PieceAllegiance) var allegiance = Util.PieceAllegiance.Neutral

export(float) var max_health = 10
export(float) var health = 10
export(float) var attack_power = 5
export(bool) var is_active = true;

onready var manager = get_node("/root/Manager")
onready var movesets = get_node("/root/Movesets")
onready var pathfinder = get_node("/root/Pathfinder")
onready var display = $Display
onready var health_label = $HealthLabel
onready var path_preview_manager = $PathPreviewManager

onready var board = manager.get_board()
var aware_of = []

var planned_path = []
var has_processed_turn: bool = true;

var is_selected: bool = false
var is_selectable: bool = true

func _ready():
	add_to_group("Piece")
	self.connect("click", self, "on_click")

	display_health()

func process_turn():
	move_along_planned_path()
	emit_signal("on_turn")
	has_processed_turn = true;

func on_click(target):
	set_selected(not is_selected)

func set_selected(state):
	is_selected = state

	if state:
		manager.set_selected_piece(self)
		emit_signal("on_selected", self)

	else:
		manager.selected_piece = null
		emit_signal("on_deselected", self)

func is_ally(piece):
	return piece.allegiance == allegiance

func set_planned_path_to(goal_cell, highlight = false):
	planned_path = pathfinder.get_shortest_path(get_cell(), goal_cell, self)
	
	if planned_path == null:
		planned_path = []
	elif highlight:
		highlight_planned_path()
		
func move_along_planned_path():
	if len(planned_path):
		var next_step = planned_path.front()

		if board.get_cell_content(next_step).is_walkable(self, true):
			move_to(planned_path.pop_front())
		
		if len(planned_path) == 0:
			clear_planned_path_highlight()
			emit_signal("reached_path_end", self)
			
		return true
	else:
		return false

func highlight_planned_path():
	path_preview_manager.show_preview(planned_path)
	
func clear_planned_path_highlight():
	path_preview_manager.clear_preview()
	
func move_to(position):
	var cell_content = board.get_cell_content(position)
	
	if cell_content.contains_enemy(self):
		cell_content.piece.die()
	
	self.position = Util.convert_to_position(position)

func attack(enemy):
	enemy.get_attacked(attack_power)

func get_attacked(dmg: int):
	health -= dmg
	display_health()
	if health <= 0:
		die()

func die():
	if is_selected:
		manager.set_selected_piece(null)
	
	is_active = false
	emit_signal("on_death", self)
	queue_free()

func display_health():
	health_label.text = str(health) + "/" + str(max_health)

func get_possible_moves(immediatly = false):
	return movesets.get_moves(self, get_cell(), board, immediatly)

func is_aware_of(piece):
	return piece in aware_of