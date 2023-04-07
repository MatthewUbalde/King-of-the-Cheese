extends CanvasLayer

@export var cheese_manager: CheeseManager

# Day and Date
@onready var day_label := %DayLabel
@onready var current_date_label := %CurrentDateLabel

# Cheese
@onready var cheese_counter_label := %CheeseCounterLabel
@onready var eaten_counter_label := %EatenCounterLabel
@onready var cheese_slider := %CheeseSlider


func _ready() -> void:
	GameEvents.update_day.connect(on_game_events_update_day)
	
#	cheese_manager.amount_update.connect(on_cheese_manager_amount_update)
	cheese_slider.value_changed.connect(on_cheese_slider_value_changed)
	
	# Uses GameEvent's current day and date by default
	update_day(GameEvents.current_day, GameEvents.current_date) 


func update_day(day: int = GameEvents.current_day, date: Dictionary = GameEvents.current_date) -> void:
	day_label.text = "Day: " + str(day)
	current_date_label.text = Ultilities.get_date_string_from_dict(date)
	
	#cheese_counter_label.text = "Cheese: " + str(day)
	
	cheese_slider.max_value = day
	cheese_slider.value = day


func on_game_events_update_day(current_day: int) -> void:
	update_day(current_day)


#func on_cheese_manager_amount_update(num_of_cheese: int) -> void:
#	#cheese_counter_label.text = "Current Cheese: " + str(num_of_cheese) 
#	#cheese_counter_label.text = "Cheese: " + str(num_of_cheese)
#	pass


func on_cheese_slider_value_changed(value: float) -> void:
	cheese_counter_label.text = "Cheese: " + str(value)
	cheese_manager.update_cheese(int(value)) 
