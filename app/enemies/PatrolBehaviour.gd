extends "Behaviour.gd"

export(NodePath) var patrol_path
export var backward = false

onready var parent = get_parent()
onready var piece = parent.get_parent()

var steps: PoolVector2Array
var current_step = 0

func process_turn():
	.process_turn()
	move_along_patrol_path()
	look_at_next_position()

func move_along_patrol_path():
	current_step = get_next_step_index()
	piece.position = steps[current_step]
	
func look_at_next_position():
	var next_step = get_next_step_index()
	parent.view_cone.look_at(steps[next_step])
	
func initialize():
	.initialize();
	var curve = get_node(patrol_path).get_curve()
	steps = curve.get_baked_points()
	
	look_at_next_position()
	
func get_next_step_index():
	if backward:
		return fmod(current_step - 1, -(steps.size() - 2))
	else:
		return fmod(current_step + 1, steps.size() - 2)