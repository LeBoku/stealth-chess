extends Node2D

onready var squares = $TileMap

func _ready():
	pass

func convert_position(x, y):
	var square_size = squares.cell_size.x
	return Vector2(x * square_size + square_size/2, y * square_size + square_size/2)
