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

#change character action access vars
var access_changing_information: action_changes_detail
var character_list_to_change: Array

@export var leave_action: export_action_base
@export var continue_action: export_action_base
@export var swap_action: export_action_base

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
		if (player.character in item.characters_connected)\
		or (global.CHARACTERS.ALL in item.characters_connected):
			
			var new_action = ACTION.instantiate()
			actions_container.add_child(new_action)
			new_action.action = item.action
			new_action.text = item.action


func action_made(action):
	if action == "swap out now":
		#ged rid of the character the player is already using
		npc.visible = false
		npc.interaction_allowed = false
		
		#bring the discarded one back
		for child in npc.get_parent().get_children():
			if child.get_node("swapping_information").swap_to == player.character:
				child.visible = true
				child.interaction_allowed = true
				
				break
		
		
		player.change_state(player.STATES.MOVING)
		player.change_character(npc.get_node("swapping_information").swap_to)
		
		visible = false
		
		return
	
	if action == "leave now":
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
			
			#iterate over list of accesses to change
			for item in dialogue[action][1]:
				access_changing_information = item
				print(item.action)
				
				
				
				
				# find a matching set and continue
				for index in range(len(actions)):
					if actions[index].action != access_changing_information.action:
						#print(actions[index].action + ": no match")
						continue
					else:
						character_list_to_change = actions[index].characters_connected
						#print(actions[index].action + ": match")
						
						# iterate over changing info to bring over to actions
						for change_indicator in access_changing_information.access_change:
							# if the same character is in both lists
							if character_list_to_change.has(change_indicator.character_to_effect):
								if change_indicator.action_access == false: # if the character is to be removed (done for safety)
									character_list_to_change.remove_at(\
									character_list_to_change.find(change_indicator.character_to_effect))
								
							#if the character is in the change list but not actions
							elif change_indicator.action_access == true: # if the character is to be added (done for safety)
								character_list_to_change.append(change_indicator.character_to_effect)
						break
				
				#print()
	
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
					make_actions([leave_action])
					return
				global.EXTRA_INTERACTIONS.GIVE_ITEM: print("GIVE_ITEM")
				global.EXTRA_INTERACTIONS.SWAP_CHARACTER: 
					make_actions([swap_action])
					return
			
			make_actions(actions)
			
		else:
			# continue extended talk
			make_actions([continue_action])
			interaction_progression += 1
	
	
	
	
	
	
