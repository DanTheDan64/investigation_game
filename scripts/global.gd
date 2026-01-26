extends Node

enum CHARACTERS{
	RACCOON,
	DOG,
	CROW,
	RABBIT,
	ALL
}

enum EXTRA_INTERACTIONS {
	NOTHING,
	CHANGE_SCENE,
	GIVE_ITEM,
	LEAVE,
	SWAP_CHARACTER
}

func _input(event):
	#camera movement
	if event is InputEventMouseMotion:
		if InputEvent:
			if Input.is_action_pressed("escape"):
				get_tree().quit()
