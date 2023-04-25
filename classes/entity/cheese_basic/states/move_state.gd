extends CheeseState

@export var idle_node: NodePath
#@export var panic_node: NodePath
#@export var relax_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node) 
#@onready var panic_state: BaseState = get_node(panic_node)
#@onready var relax_state: BaseState = get_node(relax_node)

@export var move_wait_time_range: float = 2.0
@export var move_timer: Timer
@onready var move_wait_time_base: float = move_timer.wait_time


func _ready_state() -> void:
	super._ready_state()
	
	move_timer.timeout.connect(on_move_timer_timeout)


func _enter() -> void:
	super._enter()
	
	move_timer.start(cheese.range_rand_value(move_wait_time_base, move_wait_time_range))


func _physics_process_state(delta: float) -> BaseState:
	cheese.face_movement()
	
	if cheese.move_direction.y == 0 || cheese.move_direction.x != 0:
		cheese.prev_direction = cheese.move_direction
	
	cheese.apply_speed(cheese.current_speed)
	cheese.move_and_slide()
	
	return null


func on_move_timer_timeout() -> void:
	force_change_state.emit(idle_state)



func _to_string() -> String:
	return "MoveState"


func _show_properties() -> String:
	var property_text = """
	- velocity: %s
	- move_direction: %s
	- prev_direction: %s
	- current_speed: %s"""
	return super._show_properties() + property_text % [cheese.velocity, cheese.move_direction, cheese.prev_direction, cheese.current_speed]
