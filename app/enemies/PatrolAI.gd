extends "AI.gd"

const Enemy = preload("res://app/enemies/Enemy.gd")

export(NodePath) var patrol_path
export var backward = false

onready var parent:Enemy = get_parent()

var steps: PoolVector2Array
var current_step = 0

func _ready():
	initialize_patrol()

func process_turn():
	.process_turn()
	move_along_patrol_path()
	look_at_next_position()

func move_along_patrol_path():
	current_step = get_next_step_index()
	parent.position = steps[current_step]
	
func look_at_next_position():
	var next_step = get_next_step_index()
	var view_direction = steps[next_step] - parent.position
	parent.view_indicator.rotation = view_direction.angle()
	
func initialize_patrol():
	var curve = get_node(patrol_path).get_curve()
	steps = curve.get_baked_points()
	
func get_next_step_index():
	if backward:
		return fmod(current_step - 1, -(steps.size() - 2))
	else:
		return fmod(current_step + 1, steps.size() - 2)