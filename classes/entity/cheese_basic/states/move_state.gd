extends CheeseState

@export var idle_state: BaseState

@onready var move_timer: Timer = %MoveTimer

func _ready_state() -> void:
	super._ready_state()
	
	move_timer.timeout.connect(on_move_timer_timeout)


func _enter() -> void:
	super._enter()
	
	move_timer.start(cheese.move_wait_time + Ultilities.rng.randf() * cheese.WAIT_TIME_RANGE)
	cheese.update_speed_insanity()
	
	cheese.current_speed += Ultilities.rng.randf_range(-cheese.SPEED_RAND_RANGE, cheese.SPEED_RAND_RANGE)
	
	if cheese.check_out_of_boundary():
		cheese.move_direction = Vector2.from_angle(cheese.global_position.angle_to_point(Vector2.ZERO))
		cheese.current_speed *= 1.5
	else:
		cheese.randomize_move_direction()
	
	cheese.face_movement()


func _physics_process_state(delta: float) -> BaseState:
	cheese.apply_speed(cheese.current_speed)
	cheese.apply_velocity(delta)
#	print("running??")
	
	return null


func on_move_timer_timeout() -> void:
	cheese.state_machine.change_state(idle_state)


func _to_string() -> String:
	return "MoveState"


func _show_properties() -> String:
	var property_text = """
	- velocity: %s
	- move_direction: %s
	- prev_direction: %s
	- current_speed: %s"""
	return super._show_properties() + property_text % [cheese.velocity, cheese.move_direction, cheese.prev_direction, cheese.current_speed]
