extends CanvasLayer
class_name UserInterface

@export var cheese_manager: CheeseManager

# Day and Date
@onready var day_label := %DayLabel
@onready var current_date_label := %CurrentDateLabel

# Cheese
#@onready var cheese_counter_label := %CheeseCounterLabel
@onready var eaten_counter_label := %EatenCounterLabel
#@onready var cheese_slider := %CheeseSlider

@onready var hide_button := %HideButton
@onready var tab_container := %TabContainer

func _ready() -> void:
	GameEvents.update_day.connect(on_game_events_update_day)
	ScoreManager.score_update.connect(on_score_maanger_score_update)
	
	hide_button.toggled.connect(on_hide_button_toggled)
	
	# Uses GameEvent's current day and date by default
	update_day_label() 


func update_day_label(day: int = GameEvents.current_day, date: Dictionary = GameEvents.current_date) -> void:
	day_label.text = "Day: " + str(day)
	current_date_label.text = Ultilities.get_date_string_from_dict(date)


func on_game_events_update_day(current_day: int) -> void:
	update_day_label(current_day)


func on_hide_button_toggled(button_pressed: bool) -> void:
	tab_container.visible = !button_pressed


func on_score_maanger_score_update(score: int) -> void:
	eaten_counter_label.text = "Eaten: " + str(score)
