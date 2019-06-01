extends Node2D
const Util = preload("res://app/Util.gd")

export(Util.Figures) var type = Util.Figures.Pawn

onready var piece = $Piece

func _ready():
	add_to_group("Enemy")
	
	piece.is_friend = false
	piece.type = type
