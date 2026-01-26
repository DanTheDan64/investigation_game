@tool

extends Node3D

@export var speaker_name: String = "name"
@export var starting_phrases: Array = ["hey!", "hi", "hello there"]

@export var visual: CompressedTexture2D


var actions: Array[export_action_base]

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


@onready var sprite = $StaticBody3D/Sprite3D



@onready var conversation_manager = get_tree().get_first_node_in_group("conversation_menu")
@onready var player = get_tree().get_first_node_in_group("player")

var can_interact = false
@export var interaction_allowed: bool = true


func _input(event):
	if event is InputEvent:
		if Input.is_action_just_pressed("interact"):
			if player.state != player.STATES.INTERACTING and can_interact and interaction_allowed:
				conversation_manager.start_conversation(self)


func _ready():
	dialogue.clear()
	for item in export_dialogue:
		dialogue[item.action] = [item.words, item.action_changes, item.greater_details]
		
		var action_var_mover: export_action_base = export_action_base.new()
		action_var_mover.action = item.action
		action_var_mover.characters_connected = item.characters_connected
		
		actions.append(action_var_mover)
	
	if visual:
		sprite.texture = visual


func _process(_delta):
	if Engine.is_editor_hint():
		
		if visual:
			sprite.texture = visual
		else:
			sprite.texture = "res://assets/2D/icon.svg"




func _on_interaction_range_body_entered(_body):
	can_interact = true


func _on_interaction_range_body_exited(_body):
	can_interact = false
