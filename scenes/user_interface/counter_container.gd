extends Control

@export var gui: UserInterface

var cheese_manager: CheeseManager

@onready var cheese_counter_label = %CheeseCounterLabel
@onready var cheese_label = %CheeseLabel
@onready var cheese_slider = %CheeseSlider
@onready var bypass_limit_button = %BypassLimitButton

var bypass_limit: bool = false

func _ready() -> void:
	cheese_manager = gui.cheese_manager
	
	GameEvents.update_day.connect(on_game_events_update_day)
	cheese_slider.value_changed.connect(on_cheese_slider_value_changed)
	bypass_limit_button.toggled.connect(on_bypass_limit_button_toggled) 


func on_game_events_update_day(current_day: int) -> void:
	cheese_slider.max_value = current_day
	
	# This will be available when the limit comes...
	var disable_limit_btn: bool = current_day < Ultilities.CHEESE_AMOUNT_CAP[4]
	bypass_limit_button.disabled = disable_limit_btn
	if disable_limit_btn:
		bypass_limit_button.text = "Wait til' day " + str(Ultilities.CHEESE_AMOUNT_CAP[4])
	else:
		bypass_limit_button.text = "Bypass limit " + str(Ultilities.CHEESE_AMOUNT_CAP[4])
	
	# If none of the range hits, just stay here
	if !bypass_limit:
		cheese_slider.value = cheese_manager.check_cheese_amount()
	else:
		cheese_slider.value = cheese_manager.cheese_amount_max


func on_cheese_slider_value_changed(value: float) -> void:
	cheese_manager.update_cheese(int(value))
	
	if bypass_limit:
		cheese_counter_label.text = "Cheese!? " + str(value)
		return
	
	if value < Ultilities.CHEESE_AMOUNT_CAP[0]:
		cheese_counter_label.text = "Cheese: " + str(value)
		cheese_label.text = "Adjust the amount of cheese on screen!"
	elif value < Ultilities.CHEESE_AMOUNT_CAP[1]:
		cheese_counter_label.text = "Cheese: " + str(value)
		cheese_label.text = "Adjust the amount of cheese on screen."
	elif value < Ultilities.CHEESE_AMOUNT_CAP[2]:
		cheese_counter_label.text = "Cheese! " + str(value)
		cheese_label.text = "This is impressive!"
	elif value < Ultilities.CHEESE_AMOUNT_CAP[3]:
		cheese_counter_label.text = "Cheese! " + str(value)
		cheese_label.text = "It might be too much! Be careful!"
	elif value < Ultilities.CHEESE_AMOUNT_CAP[4]:
		cheese_counter_label.text = "Cheese!! " + str(value)
		cheese_label.text = "Nice computer you got there!"
	else: # At the very limit!
		cheese_counter_label.text = "Too much!"
		cheese_label.text = "May not handle this much " + str(value) + " cheese at this point!"
		cheese_manager.update_cheese(Ultilities.CHEESE_AMOUNT_CAP[4])


func on_bypass_limit_button_toggled(button_pressed: bool) -> void:
	bypass_limit = button_pressed
	
	if bypass_limit:
		cheese_label.text = "The hard " + str(Ultilities.CHEESE_AMOUNT_CAP[4]) + " limit is gone!"
	else:
		cheese_label.text = "Well now it's gone..."
