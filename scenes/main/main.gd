extends Node


func _ready() -> void:
	GameEvents.emit_update_day()
	
	$Entities/DarkBirthday.global_position = Vector2(640 / 2, 360 / 2)
	$Entities/DarkBirthday.global_position.y += 60
