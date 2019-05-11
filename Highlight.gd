extends Sprite

signal highlight_selected

onready var board = get_node("/root/Board")

func _ready():
	add_to_group("Highlight")

func _input(event):
	if event is InputEventMouseButton and not event.pressed and board.is_same_board_position(self.position, event.position):
		emit_signal("highlight_selected", self)