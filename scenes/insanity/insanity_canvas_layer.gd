extends CanvasLayer
class_name InsanityCanvasLayer

# This is where the disturbing events happens!
@export var music_main_player: AudioStreamPlayer
@export var static_player: AudioStreamPlayer
@export var music_ending_player: AudioStreamPlayer

@onready var static_vol : float = static_player.volume_db
var static_vol_muffled := -2.4

@onready var music_main_vol : float = music_main_player.volume_db
@onready var music_main_pitch : float = music_main_player.pitch_scale
var music_vol_muffled := -4.24
var music_pitch_muffled := 0.24

@onready var color_madness_rect := $ColorMadnessRect
@onready var color_madness : Color = color_madness_rect.modulate

@onready var countdown_label := $CoundownLabel
@onready var message_label := $MessageLabel

var tween_insanity: Tween
var tween_madness: Tween
var tween_delusional: Tween
var tween_wake_up: Tween
var tween_end: Tween

func _ready() -> void:
	InsanityEvents.started.connect(on_insanity_events_started)
	
	InsanityEvents.insane.connect(on_insanity_events_insane)
	InsanityEvents.madness.connect(on_insanity_events_madness)
	InsanityEvents.delusional.connect(on_insanity_events_delusional)
	InsanityEvents.wake_ending.connect(on_insanity_events_wake_ending)
	
	InsanityEvents.ended.connect(on_insanity_events_ended)
	
	countdown_label.visible = false
	message_label.visible = false
	set_process(false)
	
	Ultilities.set_music_reverb(false)
	Ultilities.set_music_distortion(false)
	Ultilities.set_sound_effects_reverb(false)


func _process(_delta: float) -> void:
	countdown_label.text = str(roundf(InsanityEvents.time_left))


func on_insanity_events_started() -> void:
	countdown_label.visible = false
	color_madness_rect.visible = false
	
	# Set the color to original
	color_madness_rect.modulate.a = 0.0


func on_insanity_events_insane() -> void:
	Ultilities.set_sound_effects_reverb(true)
	
	# Slowly drifting to madness...
	static_player.play()
	
	countdown_label.visible = true
	set_process(true)
	color_madness_rect.visible = true
	
	if tween_insanity:
		tween_insanity.kill()
	
	var wait_time := InsanityEvents.insane_wait_time
	var wait_time_40 : float = wait_time * 0.25
	var wait_time_20 : float = wait_time * 0.1
	
	tween_insanity = create_tween().set_ease(Tween.EASE_IN)
	tween_insanity.tween_property(color_madness_rect, "modulate:a", 1.0, wait_time).set_trans(Tween.TRANS_SINE)
	tween_insanity.parallel().tween_property(countdown_label, "scale", Vector2(13.0, 13.0), wait_time - wait_time_40 + 35.0).set_delay(wait_time_40)
	tween_insanity.parallel().tween_property(static_player, "volume_db", static_vol_muffled, wait_time - wait_time_20).set_delay(wait_time_20)
	tween_insanity.parallel().tween_property(music_main_player, "volume_db", music_vol_muffled, wait_time - wait_time_40).set_delay(wait_time_40)
	tween_insanity.parallel().tween_property(music_main_player, "pitch_scale", music_pitch_muffled, wait_time - wait_time_20).set_delay(wait_time_20)


func on_insanity_events_madness() -> void:
	Ultilities.set_sound_effects_reverb(true)
	
	# Label is now seen!
	countdown_label.visible = false
	set_process(false)
	
	message_label.text = InsanityEvents.madness_message
	message_label.scale = Vector2.ZERO
	message_label.visible = true
	
	if tween_madness:
		tween_madness.kill()
	
	tween_madness = create_tween().set_ease(Tween.EASE_IN)
	tween_madness.tween_property(message_label, "scale", Vector2(9.5, 9.5), InsanityEvents.madness_wait_time + 10.0)
	Ultilities.set_music_distortion(true)


func on_insanity_events_delusional() -> void:
	Ultilities.set_sound_effects_reverb(true)
	Ultilities.set_music_distortion(true)
	music_ending_player.play()
	
	message_label.text = InsanityEvents.delusional_message
	message_label.scale = Vector2.ZERO
	
	if tween_madness:
		tween_madness.kill()
	
	tween_madness = create_tween().set_ease(Tween.EASE_OUT)
	tween_madness.tween_property(message_label, "scale", Vector2(2.8, 2.8), InsanityEvents.delusional_wait_time + 10.0)
	Ultilities.set_music_reverb(true)


func on_insanity_events_wake_ending() -> void:
	Ultilities.set_sound_effects_reverb(true)
	Ultilities.set_music_distortion(true)
	Ultilities.set_music_reverb(true)
	
	message_label.text = InsanityEvents.game_ending_message
	message_label.scale = Vector2.ZERO
	
	if tween_madness:
		tween_madness.kill()
	
	tween_madness = create_tween().set_ease(Tween.EASE_OUT)
	
	tween_madness.tween_property(message_label, "scale", Vector2(2.8, 2.8), InsanityEvents.game_ending_wait_time)
	tween_madness.parallel().tween_property(music_ending_player, "volume_db", 20.0, InsanityEvents.game_ending_wait_time)
	tween_madness.parallel().tween_property(music_ending_player, "pitch_scale", 0.2, InsanityEvents.game_ending_wait_time)
	tween_madness.parallel().tween_property(static_player, "volume_db", 0.0, InsanityEvents.game_ending_wait_time)
	tween_madness.parallel().tween_property(music_main_player, "volume_db", 0.0, InsanityEvents.game_ending_wait_time)


func on_insanity_events_complete() -> void:
	music_main_player.stop()
	music_ending_player.stop()
	static_player.stop()
	$ColorEnding.visible = true


func on_insanity_events_ended() -> void:
	message_label.text = InsanityEvents.ending_message
	
	if tween_insanity:
		tween_insanity.kill()
	
	if tween_madness:
		tween_madness.kill()
	
	if tween_end:
		tween_end.kill()
	
	
	tween_end = create_tween().set_ease(Tween.EASE_IN)
	tween_end.finished.connect(on_tween_calmness_finished, )
	
	tween_end.tween_property(countdown_label, "scale", Vector2.ZERO, 0.1)
	tween_end.parallel().tween_property(message_label, "scale", Vector2.ZERO, 0.1)
	tween_end.parallel().tween_property(color_madness_rect, "modulate:a", 0.0, 1.5)
	tween_end.parallel().tween_property(static_player, "volume_db", static_vol, 0.25)
	tween_end.parallel().tween_property(music_main_player, "volume_db", music_main_vol, 0.5)
	tween_end.parallel().tween_property(music_main_player, "pitch_scale", music_main_pitch, 0.5)
	tween_end.parallel().tween_property(music_ending_player, "volume_db", 0.0, 0.5)

func on_tween_calmness_finished() -> void:
	music_ending_player.stop()
	static_player.stop()
	
	Ultilities.set_music_reverb(false)
	Ultilities.set_music_distortion(false)
	Ultilities.set_sound_effects_reverb(false)
	
	message_label.visible = false
	countdown_label.visible = false
	color_madness_rect.visible = false
	set_process(false) # This is for the countdown!
	
	countdown_label.scale = Vector2.ONE
	message_label.scale = Vector2.ONE
