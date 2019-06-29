extends Node2D
const Util = preload("res://app/Util.gd")
const Behaviour = preload("res://app/enemies/Behaviour.gd")

onready var piece = get_parent()
onready var view_cone = $ViewCone
onready var attention_state_indicator = $AttentionState

onready var pathfinder = get_node("/root/Pathfinder")


var attention_state = Util.AttentionStates.None setget set_attention_state

var suspicious_sprite = preload("res://assets/attention_suspicious.png")
var alerted_sprite = preload("res://assets/attention_alerted.png")

func _ready():
	add_to_group("Enemy")
	piece.is_friend = false
	
	piece.connect("on_eaten", self, "queue_free")
		
	for behaviour in get_behaviour_nodes():
		behaviour.initialize()

func process_turn():
	var detected = view_cone.detect_things()
	
	if len(detected) > 0:
		view_cone.look_at_position(detected[0].position)
		self.attention_state = Util.AttentionStates.Alerted
		
		var path = pathfinder.get_shortest_path(piece.get_board_position(), detected[0].get_board_position(), piece.type)
		
		print(piece.get_board_position(), " --> ", detected[0].get_board_position())
		print(path)
		
	else:
		if attention_state == Util.AttentionStates.Alerted:
			self.attention_state = Util.AttentionStates.Suspicious
			
		for behaviour in get_behaviour_nodes():
			behaviour.process_turn()

func get_behaviour_nodes():
	var behaviours = []
	for behaviour in get_children():
		if behaviour is Behaviour and behaviour.active:
			behaviours.append(behaviour)
			
	return behaviours
	
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