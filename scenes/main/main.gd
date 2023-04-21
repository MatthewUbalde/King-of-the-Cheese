extends Node

@onready var music_player := $MusicPlayer


func _ready() -> void:
	# Randomize the randomizer seed
	Ultilities.rng.randomize()
	print_debug("RNG Seed: " + str(Ultilities.rng.seed))
	
	GameEvents.emit_update_day()
	
	# Set position to the middle
	$Entities/DarkBirthday.global_position = Vector2(640.0 / 2.0, 360.0 / 2.0)
	$Entities/DarkBirthday.global_position.y += 60.0
	
	music_player.finished.connect(on_music_player_finished)


# Go to an ongoing loop
func on_music_player_finished() -> void:
	music_player.play() 
