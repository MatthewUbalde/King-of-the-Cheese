extends Control

@export var gui_root: GUIRoot

var cheese_manager: CheeseManager

@onready var cheese_counter_label = %CheeseCounterLabel
@onready var cheese_slider = %CheeseSlider

func _ready() -> void:
	cheese_manager = gui_root.cheese_manager
	
	GameEvents.update_day.connect(on_game_events_update_day)
	cheese_slider.value_changed.connect(on_cheese_slider_value_changed)

func on_cheese_slider_value_changed(value: float) -> void:
	cheese_counter_label.text = "Cheese: " + str(value)
	cheese_manager.update_cheese(int(value)) 


func on_game_events_update_day(current_day: int) -> void:
	cheese_slider.max_value = current_day
	cheese_slider.value = current_day
