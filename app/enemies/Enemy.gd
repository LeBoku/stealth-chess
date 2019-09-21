extends Node2D
const Util = preload("res://app/Util.gd")
const PatrolHelper = preload("res://app/enemies/PatrolHelper.gd")

const suspicious_sprite = preload("res://assets/attention_suspicious.png")
const alerted_sprite = preload("res://assets/attention_alerted.png")

export var patrol_cells = PoolVector2Array()
export var view_angle = 0

onready var piece = get_parent()
onready var view_cone = $ViewCone
onready var attention_state_indicator = $AttentionState
onready var pathfinder = get_node("/root/Pathfinder")

onready var patrol_helper = PatrolHelper.new()

var attention_state = Util.AttentionStates.None setget set_attention_state
var previously_detected = []

func _ready():
	piece.add_to_group("Enemy")
	piece.allegiance = Util.PieceAllegiance.Enemy
	view_cone.set_rotation(view_angle * PI / 180)
	
	piece.connect("on_eaten", self, "on_eaten")
	piece.connect("on_turn", self, "process_turn")
	
	piece.connect("hover_enter", self, "on_hover_enter")
	piece.connect("hover_leave", self, "on_hover_leave")
	
	patrol_helper.init(piece, self, patrol_cells)

func process_turn():
	var detected = view_cone.detect_things()
	
	if len(detected) == 0 and len(previously_detected) > 0:
		for piece in previously_detected:
			if is_instance_valid(piece) and view_cone.could_see(piece.get_cell()):
				detected.append(piece)
				break
	
	previously_detected = detected
	
	if len(detected) > 0:
		self.attention_state = Util.AttentionStates.Alerted
		
		piece.set_planned_path_to((detected[0].get_cell()))
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
	
func on_eaten(piece):
	view_cone.hide_view_cone()
	queue_free()
	
func on_hover_enter(piece):
	view_cone.show_view_cone()
	piece.highlight_planned_path()
	
func on_hover_leave(piece):
	piece.clear_planned_path_highlight()
	view_cone.hide_view_cone()