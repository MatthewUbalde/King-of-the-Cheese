extends MoveState

@export var walk_state: BaseState


func _enter() -> void:
	super._enter()
	player.change_speed(true)
	player.running_particles.emitting = true


func _exit() -> void:
#	super._exit()
	player.running_particles.emitting = false

func _input_state(event : InputEvent) -> BaseState:
	var new_state: BaseState = super._input_state(event)
	
	if new_state:
		return new_state 
	
	# It'll be a hold
	if Input.is_action_just_released("move_run"): 
		return walk_state 
	return null


func _to_string() -> String:
	return "RunState"
