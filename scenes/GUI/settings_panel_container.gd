extends Control

@onready var screenshot_button = %ScreenshotButton
@onready var fullscreen_button = %FullscreenButton


func _ready() -> void:
	screenshot_button.pressed.connect(on_screenshot_button_pressed)
	fullscreen_button.toggled.connect(on_fullscreen_button_pressed)


func create_screenshot() -> void:
	var date = Time.get_datetime_dict_from_system()
	var screenshot_name = "cheese_%s.%s.%s.%s%s%s" % [date.month, date.day, date.year, date.hour, date.minute, date.second]
	Ultilities.take_screenshot(screenshot_name)


func on_screenshot_button_pressed() -> void:
	create_screenshot()


func on_fullscreen_button_pressed() -> void:
	pass
