extends Control

@export var gui: Control

@onready var message_credits_arr: Array = SecretMessage.message_credits
@onready var message_credits_container: VBoxContainer = %MessageCreditsContainer

#@onready var label_settings_credits: LabelSettings = LabelSettings.new()
@export var label_settings_credits: LabelSettings

func _ready():
	fill_credits_container(6)


#func _gui_input(event: InputEvent) -> void:


func _input(event: InputEvent) -> void:
	if event is InputEventMouse && Input.is_action_pressed("disable_mouse"):
		return
	
	if !event.is_pressed() || Input.is_action_pressed("disable_mouse"):
		return
	
	# Hide the credits and bring back the GUI
	if visible:
		visible = false
		gui.visible = !visible


func create_label(text: String, label_settings: LabelSettings = null) -> Label:
	var label: Label = Label.new()
	label.text = text
	
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if label_settings:
		label.label_settings = label_settings 
	
	return label


func fill_credits_container(max_length_word: int = -1) -> void:
	# Points to the creditted person in the array
	var pointer: int = 0
	
	while pointer < message_credits_arr.size():
		# Create a new credit line in each loop
		var message: String = ""
		
		for word in range(max_length_word): 
			if pointer >= message_credits_arr.size():
				break
			
			message += message_credits_arr[pointer] 
			pointer += 1
			if word < max_length_word - 1 && pointer < message_credits_arr.size():
				message += ", "
		
		# Inserts the text after looping for max_length_words in here
		message_credits_container.add_child(create_label(message, label_settings_credits))
