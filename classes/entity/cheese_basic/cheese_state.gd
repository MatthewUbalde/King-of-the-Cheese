extends BaseState
class_name CheeseState

var cheese: CheeseBasic


func _ready_state() -> void:
	cheese = entity as CheeseBasic


func _enter() -> void:
	if anim_enter_name:
		cheese.animation_player.play(anim_enter_name) 


func _exit() -> void:
	if anim_exit_name:
		cheese.animation_player.play(anim_exit_name)


func _input_state(event: InputEvent) -> BaseState:
	return null


func _process_state(delta: float) -> BaseState:
	return null


func _physics_process_state(delta: float) -> BaseState:
	return null


func _to_string() -> String:
	return "CheeseState"


func _show_properties() -> String:
	return _to_string() + " Properties"
