extends Control

signal setting_update(status: String)

@onready var help_label = %HelpLabel
@onready var screenshot_button = %ScreenshotButton
@onready var hint_button = %HintButton
@onready var fullscreen_button = %FullscreenButton
@onready var mute_button = %MuteButton
@onready var sound_fx_volume_slider = %SoundFXVolumeSlider
@onready var music_volume_slider = %MusicVolumeSlider
@onready var idle_timer = %IdleTimer

func _ready() -> void:
	screenshot_button.pressed.connect(on_screenshot_button_pressed)
	hint_button.pressed.connect(on_hint_button_pressed)
	fullscreen_button.toggled.connect(on_fullscreen_button_toggled)
	mute_button.toggled.connect(on_mute_button_toggled)
	
	sound_fx_volume_slider.value_changed.connect(on_sound_fx_volume_slider_value_changed)
	music_volume_slider.value_changed.connect(on_music_volume_slider_value_changed)	
	
	sound_fx_volume_slider.value = Ultilities.get_sound_bus_volume_in_db(Ultilities.SOUND_BUS_TYPE.EFFECTS)
	music_volume_slider.value = Ultilities.get_sound_bus_volume_in_db(Ultilities.SOUND_BUS_TYPE.MUSIC)
	
	idle_timer.timeout.connect(on_idle_timer_timeout)
	
	setting_update.connect(on_self_setting_update)
	
	help_label.text = SecretMessage.get_random_message()


# Temporarily moving it here to access setting_update signal
# This was poor design on my part. It makes more sense if the signal is accessed
# globally. Sorry running out of time!
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		setting_update.emit(Ultilities.create_screenshot())


func on_screenshot_button_pressed() -> void:
	setting_update.emit(Ultilities.create_screenshot())


func on_hint_button_pressed() -> void:
	help_label.text = SecretMessage.get_random_message()
	idle_timer.start()


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
	help_label.text = SecretMessage.get_random_message()

