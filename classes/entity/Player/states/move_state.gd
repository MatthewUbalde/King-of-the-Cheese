extends PlayerState
class_name MoveState

@export var idle_state: BaseState

#func _enter() -> void:
#	super._enter()
#

func _input_state(event : InputEvent) -> BaseState:
	if event.is_action_pressed("move_cancel"):
		return idle_state
	return null


func _physics_process_state(delta: float) -> BaseState:
	# If it's not using mouse input, then do keyboard!
	if !Input.is_action_pressed("move_here"):
		player.move_direction = player.get_movement_input()
	player.face_movement()
	
	if player.move_direction == Vector2.ZERO:
		return idle_state
	
	player.apply_speed(player.current_speed)
	player.apply_velocity(delta)
	
	if player.check_out_of_boundary():
		player.clamp_global_position()
	
	return null


func _to_string() -> String:
	return "MoveState"


func _show_properties() -> String:
	var property_text = """
	- velocity: %s
	- move_direction: %s
	- prev_direction: %s
	- current_speed: %s"""
	return super._show_properties() + property_text % [player.velocity, player.move_direction, player.prev_direction, player.current_speed]
