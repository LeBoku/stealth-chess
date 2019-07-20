extends Node

var preview_sprite = preload("res://assets/path_preview.png")

onready var manager = get_node("/root/Manager")
onready var board = manager.get_board()

var active_preview: Sprite

func show_preview(path):
	clear_preview()

	if len(path) > 0:
		active_preview = Sprite.new();
		active_preview.texture = preview_sprite
		board.place_element(active_preview, path[-1])

func clear_preview():
	if active_preview != null:
		active_preview.queue_free()

func _on_Piece_on_eaten():
	clear_preview()
