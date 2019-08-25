extends "res://app/BoardEntity.gd"

const enemy_view_sprite = preload("res://assets/highlight_weak.png")

onready var sprite = $Display

var type: String

func _ready():
	add_to_group("Highlight")

	if type == Util.ENEMY_VIEW_HIGHLIGHT:
		sprite.texture = enemy_view_sprite
	
func set_highlight_type(type: String):
	add_to_group(type)
	self.type = type