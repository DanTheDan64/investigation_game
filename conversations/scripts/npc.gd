@tool

extends Node3D

@export var speaker_name: String = "name"
@export var starting_phrases: Array = ["hey!", "hi", "hello there"]




@export var actions: Array[export_action_base]



@export var export_dialogue: Array[export_dialogue_base]


var dialogue: Dictionary = {
	"leave": [
		[[speaker_name,"bye"]],
		[],
		global.EXTRA_INTERACTIONS.LEAVE
		],
	"(smell)": [
		[[speaker_name,"what?"], [speaker_name,"please leave"], ["(thinking)", "they smell like disinfectant"]],
		[["(smell)", [[global.CHARACTERS.CROW, false]]], ["why do you smell like disinfectant?", true]],
		global.EXTRA_INTERACTIONS.NOTHING
		],
	"why do you smell like disinfectant?": [
		[[speaker_name,"uhhhhh"], [speaker_name,"idk"]],
		[["why do you smell like disinfectant?", [[global.CHARACTERS.CROW, false], [global.CHARACTERS.RABBIT, false]]]],
		global.EXTRA_INTERACTIONS.NOTHING
		],
}





@onready var conversation_manager = get_tree().get_first_node_in_group("conversation_menu")
@onready var player = get_tree().get_first_node_in_group("player")

var can_interact = false


func _input(event):
	if event is InputEvent:
		if Input.is_action_just_pressed("interact"):
			if player.state != player.STATES.INTERACTING and can_interact:
				conversation_manager.start_conversation(self)


func _ready():
	dialogue.clear()
	for item in export_dialogue:
		dialogue[item.action] = [item.words, item.action_changes, item.greater_details]
	
	#for item in dialogue:
		#print(item)
		#print(dialogue[item])
		#print()


func _process(_delta):
	if Engine.is_editor_hint():
		if export_dialogue.size() != actions.size():
			export_dialogue.resize(actions.size())
			#for item in export_dialogue:
				#item = 




func _on_interaction_range_body_entered(_body):
	can_interact = true


func _on_interaction_range_body_exited(_body):
	can_interact = false
