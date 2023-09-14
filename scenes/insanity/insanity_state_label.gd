extends Control

# DEBUGGING TOOL
func _ready() -> void:
	InsanityEvents.started.connect(on_insanity_events_started)
	
	InsanityEvents.insane.connect(on_insanity_events_insane)
	InsanityEvents.madness.connect(on_insanity_events_madness)
	InsanityEvents.delusional.connect(on_insanity_events_delusional)
	InsanityEvents.wake_ending.connect(on_insanity_events_wake_ending)
	
	InsanityEvents.ended.connect(on_insanity_events_ended)


func _process(_delta: float) -> void:
	%TimeLabel.text = str(InsanityEvents.time_left)


func on_insanity_events_started() -> void:
	%Label.text = "Started"


func on_insanity_events_insane() -> void:
	%Label.text = "Insane"


func on_insanity_events_madness() -> void:
	%Label.text = "Madness"


func on_insanity_events_delusional() -> void:
	%Label.text = "Delusional"


func on_insanity_events_wake_ending() -> void:
	%Label.text = "Wake GAME Ending"


func on_insanity_events_ended() -> void:
	%Label.text = "Ending"
