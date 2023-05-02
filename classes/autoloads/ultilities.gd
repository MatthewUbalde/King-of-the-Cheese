extends Node

# Game related data
const CHEESE_AMOUNT_CAP: Array = [50, 75, 250, 500, 1000]

# Directories
const USER_BASE_PATH: String = "user://"
const SCREENSHOT_DIR_NAME: String = "screenshots/"
const SCREENSHOT_NAME_FORMAT: String = "cheese_%s%s%s.%s%s%s"

const INVALID_TEMP: String = "INVALID"

const MONTH_LONG_FORM: Array[String] = [
	INVALID_TEMP, # Unexpected value
	"JANUARY",
	"FEBRUARY",
	"MARCH",
	"APRIL",
	"MAY",
	"JUNE",
	"JULY",
	"AUGUST",
	"SEPTEMBER",
	"OCTOBER",
	"NOVEMBER",
	"DECEMBER"
]

const MONTH_SHORT_FORM: Array[String] = [
	INVALID_TEMP, # Unexpected value
	"JAN",
	"FEB",
	"MAR",
	"APRIL",
	"MAY",
	"JUNE",
	"JULY",
	"AUG",
	"SEPT",
	"OCT",
	"NOV",
	"DEC"
]

enum SOUND_BUS_TYPE {
	MASTER = 0,
	MUSIC = 1,
	EFFECTS = 2
}

@onready var music_sound_bus = AudioServer.get_bus_index("Music")
@onready var sound_fx_sound_bus = AudioServer.get_bus_index("Effects")
@onready var master_sound_bus = AudioServer.get_bus_index("Master")

@onready var rng := RandomNumberGenerator.new()


func get_month_string(month_num: int, short_form: bool = false) -> String:
	if month_num < 1 || month_num > 12: 
		return INVALID_TEMP # Invalid
	
	if short_form:
		return MONTH_SHORT_FORM[month_num]
	
	return MONTH_LONG_FORM[month_num]


# Trusting that it has the same keys
func get_date_string_from_dict(date: Dictionary) -> String:
	var date_string: String = ""
	if date.month:
		date_string += get_month_string(date.month) + " "
	if date.day:
		date_string += str(date.day) + " "
	if date.year:
		date_string += ", " + str(date.year)
	
	return date_string


func create_data_folders() -> void:
	# Create empty folder
	var directories = DirAccess.open("user://") 
	directories.make_dir("screenshots") 


func take_screenshot(file_name: String) -> Error:
	var image = get_viewport().get_texture().get_image()
	#image.flip_y() as Godot 4.0 does not use OpenGL
	var error: Error = image.save_png(USER_BASE_PATH + SCREENSHOT_DIR_NAME + file_name)
	
	if error != OK:
		print_debug("Unable to take screenshot at " + USER_BASE_PATH + SCREENSHOT_DIR_NAME + file_name) 
	
	return error


func create_screenshot(file_type: String = ".png") -> String:
	var date = Time.get_datetime_dict_from_system()
	var screenshot_name =  SCREENSHOT_NAME_FORMAT % [date.month, date.day, date.year, date.hour, date.minute, date.second]
	
	var error: Error = take_screenshot(screenshot_name + file_type)
	if error != ERR_CANT_CREATE:
		print_debug("CANT CREATE! " + screenshot_name + file_type)
		return "CANT CREATE!"
	
	
	if error != OK:
		print_debug("NOT OK!"  + screenshot_name + file_type)
		return "NOT OK"
	
	
	
#	var test_path = USER_BASE_PATH + SCREENSHOT_DIR_NAME + screenshot_name + file_type
#	if FileAccess.file_exists(test_path):
#		var increment = 0
#
#		# Check for any duplicates 
#		while FileAccess.file_exists(USER_BASE_PATH + SCREENSHOT_DIR_NAME + screenshot_name + "_" + str(increment) + file_type):
#			increment += 1
#
#		screenshot_name += "_" + str(increment)
#	#print_debug(test_path)
#
#	var error: Error = take_screenshot(screenshot_name + file_type)
#	if error != OK:
#		return "Unable to create screenshot"
	
	return "Cheese~! '" + screenshot_name + "' Screenshot is taken."


func set_fullscreen(is_fullscreen: bool) -> String:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		return "Set to fullscreen"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		return "Set to windowed" 


 
func set_master_sound_bus_mute(is_mute: bool) -> String:
	if is_mute:
		AudioServer.set_bus_mute(master_sound_bus, true)
		return "All sound mute"
	else:
		AudioServer.set_bus_mute(master_sound_bus, false)
		return "All sound unmute"


func set_sound_bus_volume(value: float, type: SOUND_BUS_TYPE = SOUND_BUS_TYPE.MASTER, min: float = 30.0, max: float = 10.0) -> String:
	const message = "Adjust %s to %%%s"
	
	var readable_value = roundf(((value + min) / (min + max)) * 100) #30 is the min and the 40 is (abs(-30) + 10) with 10 the maximum
	
	match type:
		SOUND_BUS_TYPE.MUSIC:
			AudioServer.set_bus_volume_db(music_sound_bus, value)
			AudioServer.set_bus_mute(music_sound_bus, value <= -min)
			
			return message % ["Music", readable_value]
		SOUND_BUS_TYPE.EFFECTS:
			AudioServer.set_bus_volume_db(sound_fx_sound_bus, value)
			AudioServer.set_bus_mute(sound_fx_sound_bus, value <= -min)
			
			return message % ["Effects", readable_value]
	return "Invalid bus"


func get_sound_bus_volume_in_db(type: SOUND_BUS_TYPE = SOUND_BUS_TYPE.MASTER) -> float:
	match type:
		SOUND_BUS_TYPE.MUSIC:
			return AudioServer.get_bus_volume_db(music_sound_bus)
		SOUND_BUS_TYPE.EFFECTS:
			return AudioServer.get_bus_volume_db(sound_fx_sound_bus)
	return 0.0
