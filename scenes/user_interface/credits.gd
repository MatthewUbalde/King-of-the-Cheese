extends Control

@export var gui: Control

@onready var message_credits_arr: Array = SecretMessage.message_credits
@onready var hide_button: Button = %HideButton
@onready var message_credits_container: VBoxContainer = %MessageCreditsContainer

@onready var label_settings_credits: LabelSettings = LabelSettings.new()

func _ready():
	# Creating unique label settings for the credits for the easter eggs
	label_settings_credits.font_size = 20
	label_settings_credits.line_spacing = 0
	
	fill_credits_container(5)
	
	hide_button.pressed.connect(on_hide_button_pressed)


func create_label(text: String, label_settings: LabelSettings = null) -> Label:
	var label: Label = Label.new()
	label.text = text
	
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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
		#print(message)
		message_credits_container.add_child(create_label(message, label_settings_credits))


func on_hide_button_pressed() -> void:
	visible = false
	gui.visible = !visible
