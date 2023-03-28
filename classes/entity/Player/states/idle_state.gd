extends PlayerState

@export var idle_node: NodePath
@export var sit_node: NodePath
@export var walk_node: NodePath
@export var run_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
#@onready var sit_state: BaseState = get_node(sit_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var run_state: BaseState = get_node(run_node)
 

#func _process_state(delta: float) -> BaseState: 
#	return null


func _physics_process_state(delta : float) -> BaseState:
	player.move_direction = player.get_movement_input()
	
	if player.move_direction != Vector2.ZERO:
		if Input.is_action_pressed("move_run"):
			return run_state
		return walk_state
	
	player.apply_speed(player.current_speed)
	player.move_and_slide()
	
	return null


func _to_string() -> String:
	return "IdleState"


func _show_properties() -> String:
	var property_text = """
	- move_direction: %s"""
	return super._show_properties() + property_text % [player.move_direction] 
