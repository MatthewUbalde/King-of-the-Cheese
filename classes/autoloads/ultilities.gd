extends Node

# Game related data
const CHEESE_AMOUNT_CAP: Array = [30, 50, 150]

# Other data
const SCREENSHOT_DIR_PATH: String = "user://screenshots/"
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


func get_month_string(month_num: int, short_form: bool = false) -> String:
	if month_num < 1 && month_num > 12: 
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
	var directories = DirAccess.get_directories_at("user://")
	
	if directories.find(SCREENSHOT_DIR_PATH) == null:
		DirAccess.make_dir_absolute(SCREENSHOT_DIR_PATH)
		print("Created a new 'screenshot' folder")


func take_screenshot(file_name: String) -> void:
	var image = get_viewport().get_texture().get_image()
	#image.flip_y() as Godot 4.0 does not use OpenGL
	image.save_png(SCREENSHOT_DIR_PATH + file_name + ".png") 
	print("Create screenshot at " + SCREENSHOT_DIR_PATH + file_name + ".png")
	#TODO: Add a status if the screenshot is successful or not
	print("Unknown if successful.")


func create_screenshot() -> String:
	var date = Time.get_datetime_dict_from_system()
	var screenshot_name = "cheese_%s.%s.%s.%s%s%s" % [date.month, date.day, date.year, date.hour, date.minute, date.second]
	take_screenshot(screenshot_name)
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


func set_sound_bus_volume(value: float, type: SOUND_BUS_TYPE = SOUND_BUS_TYPE.MASTER) -> String:
	const message = "Adjust %s to %%%s"
	var readable_value = roundf(((value + 30) / 30) * 100) #TODO: lol
	
	print_debug("V: " + str(value) + "MV: " + str(AudioServer.get_bus_volume_db(music_sound_bus)))
	match type:
		SOUND_BUS_TYPE.MUSIC:
			AudioServer.set_bus_volume_db(music_sound_bus, value)
			#AudioServer.set_bus_mute(music_sound_bus, linear_to_db(value) < -30)
			
			return message % ["Music", readable_value]
		SOUND_BUS_TYPE.EFFECTS:
			AudioServer.set_bus_volume_db(sound_fx_sound_bus, value)
			#AudioServer.set_bus_mute(sound_fx_sound_bus, linear_to_db(value) < -30)
			
			return message % ["Effects", readable_value]
	return "Invalid bus"


func get_sound_bus_volume_in_db(type: SOUND_BUS_TYPE = SOUND_BUS_TYPE.MASTER) -> float:
	match type:
		SOUND_BUS_TYPE.MUSIC:
			return AudioServer.get_bus_volume_db(music_sound_bus)
		SOUND_BUS_TYPE.EFFECTS:
			return AudioServer.get_bus_volume_db(sound_fx_sound_bus)
	return 0.0
