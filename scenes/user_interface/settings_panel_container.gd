extends Control

signal setting_update(status: String)

@onready var help_label = %HelpLabel
@onready var screenshot_button = %ScreenshotButton
@onready var fullscreen_button = %FullscreenButton
@onready var mute_button = %MuteButton
@onready var sound_fx_volume_slider = %SoundFXVolumeSlider
@onready var music_volume_slider = %MusicVolumeSlider

func _ready() -> void:
	screenshot_button.pressed.connect(on_screenshot_button_pressed)
	fullscreen_button.toggled.connect(on_fullscreen_button_toggled)
	mute_button.toggled.connect(on_mute_button_toggled)
	
	sound_fx_volume_slider.value_changed.connect(on_sound_fx_volume_slider_value_changed)
	music_volume_slider.value_changed.connect(on_music_volume_slider_value_changed)	
	
	sound_fx_volume_slider.value = Ultilities.get_sound_bus_volume_in_db(Ultilities.SOUND_BUS_TYPE.EFFECTS)
	music_volume_slider.value = Ultilities.get_sound_bus_volume_in_db(Ultilities.SOUND_BUS_TYPE.MUSIC)
	
	setting_update.connect(on_self_setting_update)


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
