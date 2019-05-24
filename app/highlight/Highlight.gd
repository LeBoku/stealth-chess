extends Sprite

signal highlight_selected

onready var manager = get_node("/root/Manager")
onready var board = manager.get_board()

func _ready():
	add_to_group("Highlight")

func _input(event):
	if event is InputEventMouseButton and not event.pressed and board.is_same_board_position(self.position, get_global_mouse_position()):
		emit_signal("highlight_selected", self)