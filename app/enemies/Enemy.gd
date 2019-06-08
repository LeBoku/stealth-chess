extends Node2D
const Util = preload("res://app/Util.gd")
const AI = preload("res://app/enemies/AI.gd")

export(Util.Figures) var type = Util.Figures.Pawn

onready var piece = $Piece
onready var view_indicator = $ViewInidcator

func _ready():
	add_to_group("Enemy")
	
	piece.is_friend = false
	piece.type = type
	
	piece.connect("on_eaten", self, "queue_free")

func process_turn():
	for ai in get_children():
		if ai is AI and ai.active:
			ai.process_turn()