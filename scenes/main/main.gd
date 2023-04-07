extends Node


func _ready() -> void:
	GameEvents.emit_update_day()
	
	$Entities/DarkBirthday.global_position = Vector2(640.0 / 2.0, 360.0 / 2.0)
	$Entities/DarkBirthday.global_position.y += 60.0
