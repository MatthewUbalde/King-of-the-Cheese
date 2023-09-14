extends MoveState

@export var run_state: BaseState

func _enter() -> void:
	super._enter()
	player.change_speed(false)


func _input_state(event : InputEvent) -> BaseState:
	var new_state: BaseState = super._input_state(event)
	
	if new_state:
		return new_state 
		
	# It'll be a hold
	if Input.is_action_just_pressed("move_run"):
		return run_state 
	return null


func _to_string() -> String:
	return "WalkState"
