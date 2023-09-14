extends Control

@export var gui: UserInterface

var cheese_manager: CheeseManager

#@onready var counter_label = %CounterLabel
@onready var status_label = %StatusLabel
@onready var limit_button = %LimitButton
@onready var spawn_instantly_button = %SpawnInstantlyButton

@onready var spin_box = %SpinBox

var bypass_limit: bool = false
var value_int: int

func _ready() -> void:
	if gui:
		if gui.cheese_manager:
			cheese_manager = gui.cheese_manager
	else:
		gui = UserInterface.new()
		cheese_manager = CheeseManager.new()
	
	GameEvents.update_day.connect(on_game_events_update_day)
	spin_box.value_changed.connect(on_spin_box_value_changed)
	limit_button.toggled.connect(on_limit_button_toggled)
	
	spawn_instantly_button.pressed.connect(cheese_manager.spawn_cheese_instantly)
	
	spin_box.value = cheese_manager.amount_max


func on_game_events_update_day(current_day: int, _current_date: Dictionary) -> void:
	spin_box.max_value = current_day


func on_spin_box_value_changed(value: float) -> void:
	value_int = int(value)
	cheese_manager.update_cheese(value_int)
	
	gui.insanity.emit(value_int == 24 && bypass_limit)
	
	if value_int == 24:
		if bypass_limit:
			status_label.text = "There you are." 
			
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
				status_label.text = "I'm here now"
		else:
			status_label.text = "I can't find you..."
			
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
				status_label.text = "Where are you?"
			
	elif value_int < Ultilities.CHEESE_AMOUNT_CAP[0]:
		status_label.text = "Adjust the amount of cheese to spawn!"
	elif value_int < Ultilities.CHEESE_AMOUNT_CAP[1]:
		status_label.text = "Adjust the amount of cheese to spawn."
	elif value_int < Ultilities.CHEESE_AMOUNT_CAP[2]:
		status_label.text = "This is impressive!"
	elif value_int < Ultilities.CHEESE_AMOUNT_CAP[3]:
		status_label.text = "It might be too much! Be careful!"
	elif value_int < Ultilities.CHEESE_AMOUNT_CAP[4]:
		status_label.text = "Nice computer you got there!"
	else: # At the very limit!
		status_label.text = "May not handle this much " + str(value) + " cheese at this point!"


func on_limit_button_toggled(button_pressed: bool) -> void:
	bypass_limit = button_pressed
	spin_box.allow_greater = bypass_limit
	cheese_manager.bypass_limit = bypass_limit
	
	gui.insanity.emit(value_int == 24 && bypass_limit)
	
	if bypass_limit:
		if cheese_manager.amount_max == 24:
			status_label.text = "Don't worry I'm here..."
		else:
			status_label.text = "The limit is gone! BWAHAHAHA"
	else:
		status_label.text = "Well now it's back..."
