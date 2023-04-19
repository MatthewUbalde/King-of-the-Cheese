extends Control

signal setting_update(status: String)

@onready var help_label = %HelpLabel
@onready var screenshot_button = %ScreenshotButton
@onready var fullscreen_button = %FullscreenButton
@onready var mute_button = %MuteButton
@onready var sound_fx_volume_slider = %SoundFXVolumeSlider
@onready var music_volume_slider = %MusicVolumeSlider
@onready var idle_timer = %IdleTimer

func _ready() -> void:
	screenshot_button.pressed.connect(on_screenshot_button_pressed)
	fullscreen_button.toggled.connect(on_fullscreen_button_toggled)
	mute_button.toggled.connect(on_mute_button_toggled)
	
	sound_fx_volume_slider.value_changed.connect(on_sound_fx_volume_slider_value_changed)
	music_volume_slider.value_changed.connect(on_music_volume_slider_value_changed)	
	
	sound_fx_volume_slider.value = Ultilities.get_sound_bus_volume_in_db(Ultilities.SOUND_BUS_TYPE.EFFECTS)
	music_volume_slider.value = Ultilities.get_sound_bus_volume_in_db(Ultilities.SOUND_BUS_TYPE.MUSIC)
	
	idle_timer.timeout.connect(on_idle_timer_timeout)
	
	setting_update.connect(on_self_setting_update)
	
	randomize_status_default_text()


func randomize_status_default_text() -> void:
	var rand_value = randi_range(1, 5000)
	
	# I know this is easy to see if you have access to the
	# the source code, but it's fun isn't?
	if rand_value == 1:
		help_label.text = "I'm always watching..."
	elif rand_value <= 2:
		help_label.text = "mewo~"
	elif rand_value <= 3:
		help_label.text = "Oyasumi... Oyasumi! Close your eyes..."
	elif rand_value <= 4:
		help_label.text = "Onward and upward!"
	elif rand_value <= 143:
		help_label.text = "Play Omori!"
	elif rand_value <= 222:
		help_label.text = "Thank you Hat Games for making the game!"
	elif rand_value <= 413:
		help_label.text = "Putting the irons in the fire. lol"
	elif rand_value <= 1021:
		help_label.text = "Play King of the Hat!"
	elif rand_value <= 1817:
		help_label.text = "\"mad hatter, joxy'd\" - Abook"
	elif rand_value <= 1831:
		help_label.text = "i'd hat to say no"
	elif rand_value <= 1839:
		help_label.text = "ok"
	elif rand_value <= 1843:
		help_label.text = "I hat your IP hatdress"
	elif rand_value <= 3500:
		help_label.text = "Waiting for something to happen?"
	else:
		help_label.text = "Status Message!"


func on_screenshot_button_pressed() -> void:
	setting_update.emit(Ultilities.create_screenshot())


func on_fullscreen_button_toggled(button_pressed: bool) -> void:
	setting_update.emit(Ultilities.set_fullscreen(button_pressed))


func on_mute_button_toggled(button_pressed: bool) -> void:
	setting_update.emit(Ultilities.set_master_sound_bus_mute(button_pressed))


func on_sound_fx_volume_slider_value_changed(value: float) -> void:
	setting_update.emit(Ultilities.set_sound_bus_volume(value, Ultilities.SOUND_BUS_TYPE.EFFECTS))


func on_music_volume_slider_value_changed(value: float) -> void:
	setting_update.emit(Ultilities.set_sound_bus_volume(value, Ultilities.SOUND_BUS_TYPE.MUSIC))


func on_self_setting_update(status: String) -> void:
	help_label.text = status
	idle_timer.start()


func on_idle_timer_timeout() -> void:
	randomize_status_default_text()
