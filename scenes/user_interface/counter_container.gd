extends Control

@export var gui: UserInterface
@export var status_label: Label

var cheese_manager: CheeseManager

@onready var cheese_counter_label = %CheeseCounterLabel
@onready var cheese_label = %CheeseLabel
@onready var cheese_slider = %CheeseSlider

func _ready() -> void:
	cheese_manager = gui.cheese_manager
	
	GameEvents.update_day.connect(on_game_events_update_day)
	cheese_slider.value_changed.connect(on_cheese_slider_value_changed)


func on_game_events_update_day(current_day: int) -> void:
	cheese_slider.max_value = current_day
	
	# Limit ranges
	if current_day > Ultilities.CHEESE_AMOUNT_CAP[1]:
		#cheese_slider.max_value = Ultilities.CHEESE_AMOUNT_CAP[1]
		cheese_slider.value = Ultilities.CHEESE_AMOUNT_CAP[1]
		return
	
	# If none of the range hits, just stay here
	cheese_slider.value = current_day

func on_cheese_slider_value_changed(value: float) -> void: 
	if value >= Ultilities.CHEESE_AMOUNT_CAP[2]:
		cheese_counter_label.text = "Too much!"
		cheese_label.text = "Limiting the cheese to " + str(Ultilities.CHEESE_AMOUNT_CAP[2]) + ". Can't handle " + str(value) + "at this much!"
		return
	
	cheese_counter_label.text = "Cheese: " + str(value)
	cheese_manager.update_cheese(int(value))
	cheese_label.text = "Adjust the amount of cheese on area!"
	
