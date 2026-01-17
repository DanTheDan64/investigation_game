extends Control


@onready var player = get_tree().get_first_node_in_group("player")
const ACTION = preload("res://conversations/scenes/action.tscn")

@export var speaker_title: Label
@export var writing: Label
@export var actions_container: VBoxContainer

var speaker_name: String
var starting_phrases: Array
var dialogue: Dictionary

var actions: Array

var npc: Object


@onready var saved_action: Array
var interaction_progression: int = 0
var talking_information: Array

@export var leave_action: export_action_base
@export var continue_action: export_action_base

func _ready():
	visible = false


func start_conversation(source):
	npc = source
	player.change_state(player.STATES.INTERACTING)
	
	visible = true
	actions = npc.actions
	speaker_title.text = npc.speaker_name
	dialogue = npc.dialogue
	writing.text = npc.starting_phrases.pick_random()
	make_actions(actions)


func make_actions(actions_given):
	# get rid of old action list
	if actions_container.get_child_count():
		for child in actions_container.get_children():
			child.queue_free()
	
	# make new actions
	for item in actions_given:
		# if the player is using a character with access to this option
		print(item)
		if (player.character in item.character_connected)\
		or (global.CHARACTERS.ALL in item.character_connected):
			
			var new_action = ACTION.instantiate()
			actions_container.add_child(new_action)
			new_action.action = item.action
			new_action.text = item.action


func action_made(action):
	if action == "leave":
		player.change_state(player.STATES.MOVING)
		visible = false
		return
	
	if action != "continue":
		# open or close dialogue options
		# e.g just chose action smell -> close action for crow
		
		saved_action = dialogue[action]
		interaction_progression = 0
		
		#if there is stuff to iterate over
		if not dialogue[action][1].is_empty():
			
			#iterate over actions and dialoge, brute force finding matches
			
			
			var character_list_to_change_index: int
			
			# find the action and its information by iterating through actions
			for index in range(len(actions)):
				if actions[index].action == action:
					character_list_to_change_index = index
					break
			
			# find the action and its information by iterating through dialogue action_changes
			var access_changing_information: action_changes_detail
			
			for item in dialogue[action][1]: ################ look at this!!
				if item.action == action: ################ look at this!!
					access_changing_information = item ################ look at this!!
					break ################ look at this!!
			
			print(actions[character_list_to_change_index].character_connected)
			
			# iterate over changing info to bring over to actions
			for change_indicator in access_changing_information.access_change:
				# if the same character is in both lists
				if actions[character_list_to_change_index].character_connected.has(change_indicator.character_to_effect):
					if change_indicator.action_access == false: # if the character is to be removed (done for safety)
						actions[character_list_to_change_index].character_connected.remove_at(\
						actions[character_list_to_change_index].character_connected.find(change_indicator.character_to_effect))
					
				#if the character is in the change list but not actions
				elif change_indicator.action_access == true: # if the character is to be added (done for safety)
					actions[character_list_to_change_index].append()
			
			print(actions[character_list_to_change_index].character_connected)
			
	
	#speak
	talking_information = saved_action[0]
	
	if interaction_progression < len(talking_information):
		speaker_title.text = talking_information[interaction_progression].title
		writing.text = talking_information[interaction_progression].text
		
		if interaction_progression == len(talking_information) - 1:
			# final dialogue box
			match saved_action[2]:
				global.EXTRA_INTERACTIONS.NOTHING: pass
				global.EXTRA_INTERACTIONS.CHANGE_SCENE: print("CHANGE_SCENE")
				global.EXTRA_INTERACTIONS.LEAVE: 
					make_actions([continue_action])
					return
				global.EXTRA_INTERACTIONS.GIVE_ITEM: print("GIVE_ITEM")
			
			make_actions(actions)
			
		else:
			# continue extended talk
			make_actions([continue_action])
			interaction_progression += 1
	
	
	
	
	
	
