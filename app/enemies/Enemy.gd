extends Node2D
const Piece = preload("res://app/pieces/Piece.gd")
const Util = preload("res://app/Util.gd")
const PatrolHelper = preload("res://app/enemies/PatrolHelper.gd")

const suspicious_sprite = preload("res://assets/attention_suspicious.png")
const alerted_sprite = preload("res://assets/attention_alerted.png")

export var patrol_cells = PoolVector2Array()
export var view_angle = 0

onready var piece: Piece = get_parent()
onready var view_cone = $ViewCone
onready var attention_state_indicator = $AttentionState
onready var pathfinder = get_node("/root/Pathfinder")

onready var patrol_helper = PatrolHelper.new()

var attention_state = Util.AttentionStates.None setget set_attention_state
var is_ready_to_attack = false

func _ready():
	piece.add_to_group("Enemy")
	piece.allegiance = Util.PieceAllegiance.Enemy
	view_cone.set_rotation(view_angle * PI / 180)
	
	piece.connect("on_death", self, "on_death")
	piece.connect("on_turn", self, "process_turn")
	
	piece.connect("hover_enter", self, "on_hover_enter")
	piece.connect("hover_leave", self, "on_hover_leave")
	
	patrol_helper.init(piece, self, patrol_cells)

func process_turn():
	var detected = view_cone.detect_things()
	
	if len(detected) == 0 and len(piece.aware_of) > 0:
		for thing in piece.aware_of:
			if is_instance_valid(thing) and view_cone.could_see(thing.get_cell()):
				detected.append(thing)
				break
	
	piece.aware_of = detected
	
	if len(detected) > 0:
		view_cone.look_at_cell(detected[0].get_cell())

		self.attention_state = Util.AttentionStates.Alerted
		var distance_to_target = (detected[0].get_cell() - piece.get_cell()).length()
		
		if (is_ready_to_attack and Util.is_between(distance_to_target, -1.5, 1.5)):
			piece.attack(detected[0])
		else:
			is_ready_to_attack = false
			piece.set_planned_path_to(detected[0].get_cell())
	
			if(piece.planned_path):
				piece.planned_path.pop_back()
				
			if Util.is_between(distance_to_target, -2, 2):
				is_ready_to_attack = true
	
			patrol_helper.active = false
		
	else:
		if attention_state == Util.AttentionStates.Alerted:
			self.attention_state = Util.AttentionStates.Suspicious
			
		patrol_helper.active = true
		
		if len(piece.planned_path):
			view_cone.look_at_cell(piece.planned_path.back())

func set_attention_state(state):
	if state != attention_state:
		match state:
			Util.AttentionStates.None:
				attention_state_indicator.texture = null
				
			Util.AttentionStates.Suspicious:
				attention_state_indicator.texture = suspicious_sprite
				
			Util.AttentionStates.Alerted:
				attention_state_indicator.texture = alerted_sprite
		
	attention_state = state

func on_death(piece):
	view_cone.hide_view_cone()
	piece.clear_planned_path_highlight()
	queue_free()
	
func on_hover_enter(piece):
	view_cone.show_view_cone()
	piece.highlight_planned_path()
	
func on_hover_leave(piece):
	piece.clear_planned_path_highlight()
	view_cone.hide_view_cone()