extends Node2D

const Board = preload("res://app/Board.gd")

onready var board: Board = get_board()
onready var player_turn_manager: Board = get_node("/root/PlayerTurnManager")

var selected_piece = null

func _ready():
	while true:
		player_turn_manager.start_turn(get_active_pieces_in_group("Player"))
		yield(player_turn_manager, "player_turn_end")
		
		process_enemy_turn()
		yield(get_tree().create_timer(0.2), "timeout")

func set_selected_piece(piece):
	if selected_piece:
		if is_instance_valid(selected_piece):
			selected_piece.set_selected(false)
		selected_piece = null
		 
	selected_piece = piece

func _process(delta):
	if Input.is_action_just_pressed("next_turn"):
		process_enemy_turn()

func process_enemy_turn():
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Piece", "is_selectable", false)
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Enemy", "has_processed_turn", false)
	
	for piece in get_active_pieces_in_group("Enemy"):
		piece.process_turn()
	
	get_tree().set_group_flags(get_tree().GROUP_CALL_DEFAULT, "Piece", "is_selectable", true)

func get_active_pieces_in_group(group: String):
	var pieces = []
	
	for piece in get_tree().get_nodes_in_group(group):
		if piece.is_active:
			pieces.append(piece)
			
	return pieces

func get_board() -> Board:
	return get_tree().get_nodes_in_group("Board")[0]