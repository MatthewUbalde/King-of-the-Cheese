extends CanvasLayer
class_name UserInterface

signal insanity(enable: bool)

@export var cheese_manager: CheeseManager

# Day and Date
@onready var day_label := %DayLabel
@onready var current_date_label := %CurrentDateLabel

@onready var gui_node := %GUI
@onready var credits_node := %Credits

@onready var eaten_counter_label := %EatenCounterLabel
@onready var menu_button := %MenuButton
@onready var credits_button := %CreditsButton 
@onready var tab_container := %TabContainer
@onready var status_label := %StatusLabel
@onready var true_countdown_label := %TrueCountdownLabel

var tween_hide: Tween

func _ready() -> void:
	GameEvents.update_day.connect(on_game_events_update_day)
	GameEvents.anniversary.connect(on_game_events_anniversary)
	ScoreManager.score_update.connect(on_score_maanger_score_update)
	InsanityEvents.insane.connect(on_insanity_events_insane)
	InsanityEvents.ended.connect(on_insanity_events_ended)
	
	menu_button.toggled.connect(on_menu_button_toggled)
	credits_button.pressed.connect(on_credits_button_pressed)
	
	# Make sure that the tab is visiibility is updated
	tab_container.visible = menu_button.button_pressed
	
	day_label.text = "Day: " + str(GameEvents.countdown_day)
#	true_countdown_label.text = "The countdown ended on\n Aug 24, 2023!"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_here"):
		menu_button.button_pressed = false
		tab_container.visible = false


func update_anniversary_label(year_difference: int) -> void:
	status_label.text = "It has been " + str(year_difference) + " years since Dark Birthday\n loved and craved cheese..." 
	status_label.text += "\nKing of the Hat Console Anniversary!"

# The countdown is finished...
func on_game_events_update_day(_current_day: int, current_date: Dictionary) -> void:
	# Will never updated the day label from now on!
#	day_label.text = "Day: " + str(day)
	current_date_label.text = Ultilities.get_date_string_from_dict(current_date)


func on_game_events_anniversary(year_difference: int) -> void:
	update_anniversary_label(year_difference)


func on_score_maanger_score_update(score: int) -> void:
	eaten_counter_label.text = "Eaten: " + str(score)


func on_insanity_events_insane() -> void:
	if tween_hide:
		tween_hide.kill()
	
	tween_hide = create_tween().set_ease(Tween.EASE_OUT)
	
	tween_hide.tween_property($MainGUI, "modulate:a", 0.0, InsanityEvents.madness_wait_time / 2.5)
	tween_hide.finished.connect(on_tween_hide_finished, Object.ConnectFlags.CONNECT_ONE_SHOT)


func on_tween_hide_finished() -> void:
	$MainGUI.visible = false


func on_insanity_events_ended() -> void:
	$MainGUI.visible = true
	
	if tween_hide:
		tween_hide.kill()
	
	tween_hide = create_tween().set_ease(Tween.EASE_IN)
	tween_hide.tween_property($MainGUI, "modulate:a", 1.0, 1)


func on_menu_button_toggled(button_pressed: bool) -> void:
	tab_container.visible = button_pressed


func on_credits_button_pressed() -> void:
	credits_node.visible = !credits_node.visible
	gui_node.visible = !credits_node.visible
