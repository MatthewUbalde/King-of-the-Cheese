extends BaseState
class_name PlayerState

var player: Player


func _ready_state() -> void:
	player = entity as Player


func _enter() -> void:
	if anim_enter_name:
		player.animation_player.play(anim_enter_name) 


#func _exit() -> void:
##	if anim_exit_name:
##		player.animation_player.play(anim_exit_name)
#	pass
#
#
#func _input_state(event: InputEvent) -> BaseState:
#	return null
#
#
#func _process_state(delta: float) -> BaseState:
#	return null
#
#
#func _physics_process_state(delta: float) -> BaseState:
#	return null


func _to_string() -> String:
	return "PlayerState"


func _show_properties() -> String:
	return _to_string() + " Properties"
