extends Sprite

onready var manager = get_node("/root/Manager")
onready var board = manager.get_board()

onready var piece = get_parent().get_parent()

func detect_things():
	var detected = []
	for detectable in get_detectables():
		if is_in_view(detectable):
			detected.append(detectable)
		
	return detected

func look_at_position(position):
	var view_direction = position - piece.position
	rotation = view_direction.angle()

func is_in_view(thing):
	var direction_to_thing = (thing.position - piece.position).normalized() 
	var view_direction  = piece.position.rotated(rotation).normalized();
	
	print(view_direction.dot(direction_to_thing))
	return view_direction.dot(direction_to_thing) > 0
	
func get_detectables():
	var detectable = []
	
	for piece in board.get_all_pieces():
		if piece.is_friend:
			detectable.append(piece)

	return detectable