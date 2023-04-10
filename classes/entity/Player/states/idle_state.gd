extends PlayerState

@export var idle_node: NodePath
@export var sit_node: NodePath
@export var walk_node: NodePath
@export var run_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
#@onready var sit_state: BaseState = get_node(sit_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var run_state: BaseState = get_node(run_node)
 

@export var idle_anim_timer: Timer

#func _process_state(delta: float) -> BaseState: 
#	return null

func _ready_state() -> void:
	super._ready_state()
	
	idle_anim_timer.timeout.connect(on_idle_anim_timer_timeout)


func _enter() -> void:
	super._enter()
	idle_anim_timer.start()


func _exit() -> void:
	super._exit()
	idle_anim_timer.stop()


func _physics_process_state(delta : float) -> BaseState:
	player.move_direction = player.get_movement_input() 
	
	if player.move_direction != Vector2.ZERO:
		if Input.is_action_pressed("move_run"):
			return run_state
		return walk_state
	
	return null


func on_idle_anim_timer_timeout() -> void:
	player.animation_player.play(anim_enter_name)


func _to_string() -> String:
	return "IdleState"


func _show_properties() -> String:
	var property_text = """
	- global_position: %s
	- move_direction: %s"""
	return super._show_properties() + property_text % [player.global_position, player.move_direction] 
