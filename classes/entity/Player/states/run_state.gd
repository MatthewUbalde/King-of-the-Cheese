extends MoveState


func _input_state(event : InputEvent) -> BaseState:
	var new_state = super._input_state(event)
	
	if new_state:
		return new_state 
	
	# It'll be a hold
	if Input.is_action_just_released("move_run"): 
		return walk_state 
	return null


func _physics_process_state(delta: float) -> BaseState:
	player.change_speed(player.speed_type.RUN)
	var new_state = super._physics_process_state(delta)
	
	if new_state:
		return new_state 
	
	return null


func _to_string() -> String:
	return "RunState"
