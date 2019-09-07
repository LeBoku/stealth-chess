var piece
var piece_controller
var patrol_cells: PoolVector2Array

var active = true

func init(piece, piece_controller, patrol_cells):
	self.piece = piece
	self.piece_controller = piece_controller
	self.patrol_cells = patrol_cells
	
	piece.connect("on_turn", self, "process_turn")
	piece.connect("ready", self, "start_patrol_to_closest_cell")

func start_patrol_to_closest_cell():
	var closest_patroll_cell = find_closest_patrol_cell();
	if closest_patroll_cell != null:
		piece.set_planned_path_to(closest_patroll_cell)
		piece_controller.view_cone.look_at_cell(closest_patroll_cell)

func process_turn():
	if len(piece.planned_path):
		piece_controller.view_cone.look_at_cell(piece.planned_path.back())
	if active and len(piece.planned_path) == 0:
		start_patrol_to_closest_cell()
	
func find_closest_patrol_cell():
	var piece_cell = piece.get_cell()
	var closest = null
	var closest_distance = 256
	
	for patrol_cell in patrol_cells:
		var current_distance = (piece_cell - patrol_cell).length()
		if current_distance != 0 and (closest == null or current_distance < closest_distance):
			closest = patrol_cell
			closest_distance = current_distance
			
	return closest