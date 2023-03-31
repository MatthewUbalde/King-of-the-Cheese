extends CheeseState

@export var move_node: NodePath
#@export var panic_node: NodePath
#@export var relax_node: NodePath

@onready var move_state: BaseState = get_node(move_node)
#@onready var panic_state: BaseState = get_node(panic_node)
#@onready var relax_state: BaseState = get_node(relax_node)

@export var idle_wait_time_range := 3.0
@export var idle_timer: Timer

@onready var idle_wait_time_base: float = idle_timer.wait_time


func _ready_state() -> void:
	super._ready_state()
	
	idle_timer.timeout.connect(on_idle_timer_timeout)


func _enter() -> void:
	super._enter()
	
	idle_timer.start(cheese.range_rand_value(idle_wait_time_base, idle_wait_time_range))


func on_idle_timer_timeout() -> void:
	cheese.randomize_move_direction()
	force_change_state.emit(move_state) 


func _to_string() -> String:
	return "IdleState"


func _show_properties() -> String:
	var property_text = """
	- global_position: %s
	- idle_time time_left: %s"""
	return super._show_properties() + property_text % [cheese.global_position, idle_timer.time_left] 
