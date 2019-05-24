extends Node

export(NodePath) var patrol_path
export var backward = false

onready var parent = get_parent()

var steps: PoolVector2Array
var current_step = 0

func _ready():
	var curve = get_node(patrol_path).get_curve()
	steps = curve.get_baked_points()

func move_along_patrol_path():
		current_step = get_next_step()
		parent.position = steps[current_step]
		
func get_next_step():
	if backward:
		return fmod(current_step - 1, -(steps.size() - 2))
	else:
		return fmod(current_step + 1, steps.size() - 2)