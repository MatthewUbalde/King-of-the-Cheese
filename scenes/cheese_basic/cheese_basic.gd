extends Entity
class_name CheeseBasic

@export var speed_rand_range := 10.0

func range_rand_value(base: float, range_num: float) -> float:
	return base + randf_range(-range_num, range_num)


func _ready() -> void: 
	randomize_move_direction()
	face_movement()
	current_speed = range_rand_value(speed_base, speed_rand_range)


func _process(delta) -> void:
	if $Label.visible:
		$Label.text = $StateMachine.current_state._show_properties()


func _physics_process(delta: float) -> void:
	#TODO: Temp fix for barrier
	global_position = Vector2(
		clamp(global_position.x, -1250, 1250),
		clamp(global_position.y, -1250, 1250),
	)

func randomize_move_direction() -> void:
	move_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))  
	prev_direction = move_direction
