extends Area2D
class_name HearableAreaComponent


func _ready() -> void:
	area_entered.connect(on_self_area_entered)
	area_exited.connect(on_self_area_exited)


func on_self_area_entered(area: Area2D) -> void:
	if get_overlapping_bodies().size() < 5:
		(area as HurtboxComponent).parent.add_sound_child()


func on_self_area_exited(area: Area2D) -> void:
	(area as HurtboxComponent).parent.remove_sound_child()

