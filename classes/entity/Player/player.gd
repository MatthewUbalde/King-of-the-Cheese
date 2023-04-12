extends Entity
class_name Player

@onready var hitbox: HitboxComponent = $HitboxComponent


func _ready() -> void:
	hitbox.hit.connect(on_hitbox_hit)
	
	var rng_result = (randi_range(1, 1000) / 1000.0) == 0.0
	$Visual/CheeseSprite2D.visible = rng_result
	$Visual/AnimatedSprite2D.visible = !rng_result


func _process(delta: float) -> void:
	if $Label.visible:
		$Label.text = $StateMachine.current_state._show_properties()


func _physics_process(delta: float) -> void:
	#TODO: Temp fix for barrier
	global_position = Vector2(
		clamp(global_position.x, -1250, 1250),
		clamp(global_position.y, -1250, 1250),
	)
	
	hitbox.active = Input.is_action_pressed("player_action") 


func change_speed(type: speed_type = speed_type.WALK) -> void:
	match type:
		speed_type.WALK:
			current_speed = speed_base
		speed_type.RUN:
			current_speed = speed_running
		_:
			current_speed = speed_base


func get_movement_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


#Signals
func on_hitbox_hit() -> void: 
	$YumSound.play()
	ScoreManager.increase_by_score(ScoreManager.score_type.DEFAULT)
