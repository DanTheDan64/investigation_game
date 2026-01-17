extends Button


var action = ""


func _on_pressed():
	get_parent().conversation_menu.action_made(action)
