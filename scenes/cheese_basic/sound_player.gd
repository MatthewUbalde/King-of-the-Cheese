extends AudioStreamPlayer2D
class_name SoundPlayer

# This is such a hack on optimization with the AudioThread
#so sorry if it's really messy! It's the only thing that makes the game
#slow down is due to the huge amount of AudioStreamPlayer2D being created.
#A better and cleaner alternative would be nice!

# Essentially, it'll get added to the cheese_basic if they
#get hit by Dark Birthday. If they did, then a signal is passed to the
#cheese, then the cheese will spawn this in and will use that to play 
#the sound.
# The sound will be removed once they're out of the area2D

func play_sound(audio: AudioStream) -> void:
	stream = audio
	volume_db = 0
	play()


func play_sound_vol(audio: AudioStream, volume: float) -> void:
	stream = audio
	volume_db = volume
	play()
