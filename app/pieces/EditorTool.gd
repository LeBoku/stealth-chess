tool
extends Node

const Util = preload("res://app/Util.gd")

onready var piece = get_parent()
onready var display = $"../Display"

const sprites = {
	Util.Figures.Pawn: preload("res://assets/pawn.png"),
	Util.Figures.Rook: preload("res://assets/rook.png"),
	Util.Figures.Knight: preload("res://assets/knight.png"),
	Util.Figures.Bishop: preload("res://assets/bishop.png"),
	Util.Figures.King: preload("res://assets/king.png"),
	Util.Figures.Queen: preload("res://assets/queen.png")
}

func _process(delta):
	if display != null and piece != null:
		display.texture = sprites[piece.type]