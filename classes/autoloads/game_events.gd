extends Node

signal update_day(current_day: int)

const SECONDS_PER_DAY = 86_400.0

var current_date: Dictionary
var starting_date: Dictionary = { # Technically March 10, 2023, but it doesn't calculate the day right
	"year": 2023,
	"month": 3,
	"day": 9,
	"weekday": 4
}

var current_day := 1
var previous_day := 0


func _ready() -> void:
	Ultilities.create_data_folders()
	
	$Timer.timeout.connect(on_timer_timeout)
	
	current_date = Time.get_date_dict_from_system(false)
	update_current_day()


func _input(input: InputEvent) -> void:
	if !Input.is_action_pressed("cheat_dev"):
		return
	
	if input.is_action_pressed("ui_page_down"):
		current_date.day -= 1
	
	if input.is_action_pressed("ui_page_up"):
		current_date.day += 1
	
	# Debugging purposes
	$Timer.stop()
	update_current_day()


func update_current_day() -> void:
	var unix_current_date := Time.get_unix_time_from_datetime_dict(current_date)
	var unix_starting_date := Time.get_unix_time_from_datetime_dict(starting_date)
	
	current_day = calculate_day_difference_with_unix_time(unix_current_date, unix_starting_date)
	
	# Update when outdated
	if current_day != previous_day:
		emit_update_day() 
		previous_day = current_day 


func calculate_day_difference_with_unix_time(lhs: float, rhs: float) -> int:
	return roundi((lhs - rhs) / SECONDS_PER_DAY)


func on_timer_timeout() -> void:
	current_date = Time.get_date_dict_from_system(false)
	update_current_day() 


func emit_update_day() -> void:
	update_day.emit(current_day)

