extends Node

signal update_day(current_day: int, current_date: Dictionary)
signal anniversary(year_difference: int)

const SECONDS_PER_DAY := 86_400.0

var current_date: Dictionary
var starting_date: Dictionary = { # Technically March 10, 2023, but it doesn't calculate the day right
	"year": 2023,
	"month": 3,
	"day": 9,
	"weekday": 5
}

var ending_date: Dictionary = { # Ends on this day...
	"year": 2023,
	"month": 8,
	"day": 24,
	"weekday": 4
}

var countdown_day := 0 # True count of days
var current_day := 1
var amount_day := 1
var day_reduction := 5 # Because Redino missed some days. :c
var previous_day := 0

func _ready() -> void:
	Ultilities.create_data_folders()
	
	$Timer.timeout.connect(on_timer_timeout)
	
	current_date = Time.get_date_dict_from_system(false)
	
	# Check to see if the anniversary is today
	if ending_date.month == current_date.month && ending_date.day == current_date.day:
		anniversary.emit(current_date.year - ending_date.year)
	
	var unix_starting_date := Time.get_unix_time_from_datetime_dict(starting_date)
	var unix_ending_date := Time.get_unix_time_from_datetime_dict(ending_date)
	
	countdown_day = calculate_day_difference_with_unix_time(unix_ending_date, unix_starting_date) - day_reduction
	
	update_current_day()


func _input(input: InputEvent) -> void:
	if !input.is_action_pressed("cheat_dev"):
		return
	
	if input.is_action_pressed("ui_page_down"):
		current_day -= 1
	elif input.is_action_pressed("ui_page_up"):
		current_day += 1
	
	$Timer.stop()
	update_day.emit(current_day, current_date)


func update_current_day() -> void:
	var unix_current_date := Time.get_unix_time_from_datetime_dict(current_date)
	var unix_starting_date := Time.get_unix_time_from_datetime_dict(starting_date)
	
	current_day = calculate_day_difference_with_unix_time(unix_current_date, unix_starting_date)
	
	current_day -= day_reduction
	
	# Update when outdated
	if current_day != previous_day:
		update_day.emit(current_day, current_date)
		previous_day = current_day 


func calculate_day_difference_with_unix_time(lhs: float, rhs: float) -> int:
	return roundi((lhs - rhs) / SECONDS_PER_DAY)


func on_timer_timeout() -> void:
	current_date = Time.get_date_dict_from_system(false)
	update_current_day() 


func emit_update_day() -> void:
	update_day.emit(current_day, current_date)

