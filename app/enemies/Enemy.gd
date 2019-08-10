extends Node2D
const Util = preload("res://app/Util.gd")
const PatrolHelper = preload("res://app/enemies/PatrolHelper.gd")

const suspicious_sprite = preload("res://assets/attention_suspicious.png")
const alerted_sprite = preload("res://assets/attention_alerted.png")

export var patrol_cells = PoolVector2Array()

onready var piece = get_parent()
onready var view_cone = $ViewCone
onready var attention_state_indicator = $AttentionState
onready var pathfinder = get_node("/root/Pathfinder")

onready var patrol_helper = PatrolHelper.new()

var attention_state = Util.AttentionStates.None setget set_attention_state

func _ready():
	add_to_group("Enemy")
	piece.is_friend = false
	
	piece.connect("on_eaten", self, "queue_free")
	piece.connect("on_turn", self, "process_turn")
	
	patrol_helper.init(piece, self, patrol_cells)

func process_turn():
	var detected = view_cone.detect_things()
	
	if len(detected) > 0:
		view_cone.look_at_cell(detected[0].get_cell())
		self.attention_state = Util.AttentionStates.Alerted
		
		piece.set_planned_path_to((detected[0].get_cell()))
		patrol_helper.active = false
		
	else:
		if attention_state == Util.AttentionStates.Alerted:
			self.attention_state = Util.AttentionStates.Suspicious
			
		patrol_helper.active = true

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