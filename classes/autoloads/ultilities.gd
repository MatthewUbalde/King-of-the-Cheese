extends Node

const SCREENSHOT_DIR_PATH = "user://screenshots/"
const INVALID_TEMP = "INVALID"

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
	
	if directories.find("SCREENSHOT_DIR_PATH") == null:
		DirAccess.make_dir_absolute(SCREENSHOT_DIR_PATH)
		print("Created a new 'screenshot' folder")


func take_screenshot(file_name: String) -> void:
	var image = get_viewport().get_texture().get_image()
	#image.flip_y() as Godot 4.0 does not use OpenGL
	image.save_png(SCREENSHOT_DIR_PATH + file_name + ".png") 
	print("Create screenshot at " + SCREENSHOT_DIR_PATH + file_name + ".png")
	#TODO: Add a status if the screenshot is successful or not
	print("Unknown if successful.")


func set_fullscreen(is_fullscreen: bool) -> String:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		return "Set to fullscreen"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		return "Set to windowed" 
