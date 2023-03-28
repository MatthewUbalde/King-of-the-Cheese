extends Node


func _ready() -> void:
	GameEvents.emit_update_day()
	
	$Entities/DarkBirthday.global_position = $Background/ColorRect.size / 2
	$Entities/DarkBirthday.global_position.y += 35
