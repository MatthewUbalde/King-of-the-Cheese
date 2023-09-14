extends Node

const IDLE_MESSAGE: String = "Currently dreaming..."
const ACTIVE_MESSAGE: String = "Currently eating cheese!"

@onready var player: Player = %DarkBirthday

@onready var music_player := $MusicPlayer
@onready var static_player := $StaticPlayer
@onready var ending_music_player := $EndingMusicPlayer
@onready var animation_player := $AnimationPlayer
@onready var transition_screen := $Transition

@onready var cheese_manager: CheeseManager = $CheeseManager
@onready var user_interface: UserInterface = $UserInterface
@onready var discord_update_timer := $DiscordUpdateTimer

var has_discord: bool = false
var can_insane: bool = false

func _ready() -> void:
	# Randomize the randomizer seed
	Ultilities.rng.randomize()
#	print_debug("RNG Seed: " + str(Ultilities.rng.seed))
	Ultilities.create_data_folders()
	GameEvents.emit_update_day()
	
	# Discord Rich Presense
	discord_sdk.app_id = 1145527867627798548
	# this is boolean if everything worked
	has_discord = discord_sdk.get_is_discord_working()
	print("Discord working: " + str(has_discord))
	
	if has_discord:
		discord_sdk.details = "Cheese. Eat. Cheese."
		discord_sdk.state = ACTIVE_MESSAGE
		discord_sdk.large_image = "cheese_logo"
		discord_sdk.large_image_text = ":D"
		discord_sdk.small_image = "cheese_small_sprite"
		discord_sdk.small_image_text = "0 cheeses"
		discord_sdk.start_timestamp = int(Time.get_unix_time_from_system())
		discord_sdk.refresh()
		discord_update_timer.start()
	
	# Set position to the middle
	player.global_position = Vector2.ZERO#Vector2(640.0 / 2.0, 360.0 / 2.0)
	player.global_position.y += 60.0
	(player as Player).eaten_timer.timeout.connect(on_player_eaten_timer_timeout)
	(player as Player).eat_cheese.connect(on_player_eat_cheese)
	(player as Player).sitting.connect(on_player_sitting)
	(player as Player).moving.connect(on_player_moving)
	
	music_player.finished.connect(on_music_player_finished)
	static_player.finished.connect(on_static_player_finished)
	ending_music_player.finished.connect(on_ending_music_player_finished)
	animation_player.animation_finished.connect(on_animation_player_finished, Object.CONNECT_ONE_SHOT)
	user_interface.insanity.connect(on_user_interface_insanity)
	discord_update_timer.timeout.connect(on_discord_update_timer_timeout)


func _input(event: InputEvent) -> void:
	if InsanityEvents.in_madness:
		return
	
	if event.is_action_pressed("hide_gui"):
		$UserInterface.visible = !$UserInterface.visible
	
	if event.is_action_pressed("escape_key"):
		Ultilities.set_fullscreen(false)


#func _process(delta: float) -> void: 
#	madness_label.text = str(roundf(madness_timer.time_left))


# Go to an ongoing loop
func on_music_player_finished() -> void:
	music_player.play()


func on_static_player_finished() -> void:
	if InsanityEvents.in_madness:
		static_player.play()


func on_ending_music_player_finished() -> void:
	if InsanityEvents.in_madness:
		ending_music_player.play()


func on_animation_player_finished(_anim_name: StringName) -> void:
	transition_screen.queue_free()
	animation_player.queue_free()


func on_player_eat_cheese() -> void:
	# Only if there's 24 cheese on the field and has bypass the limit
#	if cheese_manager.amount_max != 24 || !cheese_manager.bypass_limit:
	if !can_insane:
		return
	
	# Starts to lose insanity
	if !InsanityEvents.in_madness:
		$InsanityCanvasLayer.visible = true
		discord_update_timer.stop()
		InsanityEvents.start()


func on_player_eaten_timer_timeout() -> void:
	if !can_insane:
		return
	
	if InsanityEvents.in_madness:
		$InsanityCanvasLayer.visible = false
		discord_update_timer.start()
		InsanityEvents.end()


func on_user_interface_insanity(enable: bool) -> void:
	can_insane = enable


func on_discord_update_timer_timeout() -> void:
	has_discord = discord_sdk.get_is_discord_working()
	discord_sdk.small_image_text = str(ScoreManager.score_current) + " cheeses"
	discord_sdk.refresh()


func on_player_sitting() -> void:
	if has_discord:
		discord_sdk.state = IDLE_MESSAGE
		discord_sdk.refresh()


func on_player_moving() -> void:
	if has_discord:
		discord_sdk.state = ACTIVE_MESSAGE
		discord_sdk.refresh()
