extends Node2D
const Util = preload("res://app/Util.gd")
const Behaviour = preload("res://app/enemies/Behaviour.gd")

export(Util.Figures) var type = Util.Figures.Pawn

onready var piece = $Piece
onready var view_cone = $ViewCone

func _ready():
	add_to_group("Enemy")
	
	piece.is_friend = false
	piece.type = type
	
	piece.connect("on_eaten", self, "queue_free")
		
	for behaviour in get_behaviour_nodes():
		behaviour.initialize()

func process_turn():
	var detected = view_cone.detect_things()
	
	if len(detected) > 0:
		view_cone.look_at_position(detected[0].position)
	else:
		for behaviour in get_behaviour_nodes():
			behaviour.process_turn()

func get_behaviour_nodes():
	var behaviours = []
	for behaviour in get_children():
		if behaviour is Behaviour and behaviour.active:
			behaviours.append(behaviour)
			
	return behaviours