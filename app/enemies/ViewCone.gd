extends Sprite

const Util = preload("res://app/Util.gd")

onready var manager = get_node("/root/Manager")
onready var highlight_manager = get_node("/root/Manager/HighlightManager")
onready var board = manager.get_board()

onready var piece = get_parent().get_parent()

const view_cone_spread =  [
	-Util.RAD_45_DEG,
	-Util.RAD_30_DEG,
	-Util.RAD_15_DEG,
	0, 
	+Util.RAD_15_DEG,
	+Util.RAD_30_DEG,
	+Util.RAD_45_DEG
]

func detect_things():
	var detected = []
	
	for cell in get_visible_cells():
		var content = board.get_cell_content(cell)
		if content.piece and content.piece.is_friend:
			detected.append(content.piece)

	return detected

func look_at_cell(cell):
	var view_direction = cell - piece.get_cell()
	rotation = round(view_direction.angle() / Util.RAD_45_DEG) *  Util.RAD_45_DEG

func get_visible_cells():
	var cells = []
	var piece_cell = piece.get_cell()
	
	for spread in view_cone_spread:
		var current_rotation = rotation + spread
		var view_vector = Vector2(cos(current_rotation), sin(current_rotation)).normalized()

		for i in range(1, 5):
			var cell = Util.round_to_cell(piece_cell + view_vector * i)
			var cell_content = board.get_cell_content(cell)
			
			if cell_content.type != Util.CellType.Empty:
				break
			elif not cells.has(cell):
				cells.append(cell);
		
	return cells
	
func show_view_cone():
	for cell in get_visible_cells():
		highlight_manager.add_highlight(cell, Util.ENEMY_VIEW_HIGHLIGHT)
	
func hide_view_cone():
	highlight_manager.clear_highlights(Util.ENEMY_VIEW_HIGHLIGHT)