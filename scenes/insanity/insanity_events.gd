extends Node

# This only handles the timing, not the effects,
#everyone should have access to this node

# These are signals that are fired upon reaching those states
# States of insanity
signal started
signal insane
signal madness
signal delusional
signal wake_ending
signal complete

# States of calming down
signal ended

@export var insane_wait_time : float = 30
@export var madness_wait_time : float = 120
@export_multiline var madness_message: String
@export var delusional_wait_time : float = 24
@export_multiline var delusional_message: String
@export var game_ending_wait_time : float = 7
@export_multiline var game_ending_message: String
@export var complete_wait_time : float = 3

@export_multiline var ending_message: String

#@export var discord_state_start: String
@export var discord_state_insane: String
@export var discord_state_madness: String
@export var discord_state_delusional: String
@export var discord_state_game_ending: String
@export var discord_state_end: String

@onready var state_timer := $StateTimer

var in_madness: bool = false
var time_left: float = 0.0

enum InsanityState { CALM, INSANE, MADNESS, DELUSIONAL, WAKE_ENDING }
var current_state: InsanityState = InsanityState.CALM

func _ready() -> void:
	started.connect(on_self_started)

	insane.connect(on_self_insane)
	madness.connect(on_self_madness)
	delusional.connect(on_self_delusional)
	wake_ending.connect(on_self_wake_ending)
	
	ended.connect(on_self_ended)
	set_process(false)
	
	state_timer.timeout.connect(on_state_timer_timeout)


func _process (_delta: float) -> void:
	time_left = $StateTimer.time_left


func start() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		return
	
	# When emitted, it'll start the states in the following
	# Insane > Madness > Delusional > Wake Ending
	started.emit()
	current_state = InsanityState.CALM


func end() -> void:
	# When emitted, it'll transition back to normal!
	ended.emit()
	current_state = InsanityState.CALM


func finish() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func on_state_timer_timeout() -> void:
	match current_state:
		InsanityState.CALM:
			insane.emit()
		InsanityState.INSANE:
			madness.emit()
		InsanityState.MADNESS:
			delusional.emit()
		InsanityState.DELUSIONAL:
			wake_ending.emit()
		InsanityState.WAKE_ENDING:
			finish()
	
#	print_debug(current_state)


func on_self_started() -> void:
	in_madness = true
	set_process(true)
	state_timer.start(insane_wait_time)


func on_self_insane() -> void:
	set_process(true)
	state_timer.start(madness_wait_time)
	current_state = InsanityState.INSANE
	if discord_sdk.get_is_discord_working():
		discord_sdk.state = discord_state_insane
		discord_sdk.refresh()


func on_self_madness() -> void:
	set_process(false)
	state_timer.start(delusional_wait_time)
	current_state = InsanityState.MADNESS
	if discord_sdk.get_is_discord_working():
		discord_sdk.state = discord_state_madness
		discord_sdk.refresh()


func on_self_delusional() -> void:
	set_process(false)
	state_timer.start(game_ending_wait_time)
	current_state = InsanityState.DELUSIONAL
	if discord_sdk.get_is_discord_working():
		discord_sdk.state = discord_state_delusional
		discord_sdk.refresh()


func on_self_wake_ending() -> void:
	set_process(false)
	state_timer.start(complete_wait_time)
	current_state = InsanityState.WAKE_ENDING
	complete.emit() # The cycle is complete
	if discord_sdk.get_is_discord_working():
		discord_sdk.state = discord_state_game_ending
		discord_sdk.refresh()


func on_self_ended() -> void:
	in_madness = false
	set_process(false)
	state_timer.stop()
	if discord_sdk.get_is_discord_working():
		discord_sdk.state = discord_state_end
		discord_sdk.refresh()
