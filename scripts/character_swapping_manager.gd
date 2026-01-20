extends Node


@onready var player = get_tree().get_first_node_in_group("player")


func _ready():
	for child in get_children():
		if child.get_node("swapping_information").swap_to == player.character:
			child.visible = false
			child.interaction_allowed = false
			break
