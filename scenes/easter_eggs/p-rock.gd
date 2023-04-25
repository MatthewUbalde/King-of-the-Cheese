extends Node2D

# I didn't recognized what the phrase meant, so I'm like really sorry.
# I just bursted in laughter because of how loud it was, and accepted it.
# so sorry sorry if this was weird. or i'm weird.

var nearby_player: Player



func _ready() -> void:
	$Area2D.body_entered.connect(on_area_2d_body_entered)
	$Area2D.body_exited.connect(on_area_2d_body_exited)


func _input(event: InputEvent) -> void:
	if nearby_player == null:
		return
	
	if event.is_action_pressed("player_interact") && !$AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()


func on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		nearby_player = body


func on_area_2d_body_exited(body: Node2D) -> void:
	nearby_player = null
