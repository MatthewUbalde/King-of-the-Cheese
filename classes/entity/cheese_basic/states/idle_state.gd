extends CheeseState

@export var move_state: BaseState

@onready var idle_timer: Timer = %IdleTimer


func _ready_state() -> void:
	super._ready_state()
	idle_timer.timeout.connect(on_idle_timer_timeout)


func _enter() -> void:
	super._enter()
	
	idle_timer.start(cheese.idle_wait_time + Ultilities.rng.randf() * cheese.WAIT_TIME_RANGE)
	cheese.face_movement()


func on_idle_timer_timeout() -> void:
	cheese.state_machine.change_state(move_state)


func _to_string() -> String:
	return "IdleState"


func _show_properties() -> String:
	var property_text = """
	- global_position: %s
	- idle_time time_left: %s"""
	return super._show_properties() + property_text % [cheese.global_position, cheese.state_timer.time_left] 
