extends Entity
class_name Player

@export var anim_sprite: AnimatedSprite2D
@export var cheese_sprite: Sprite2D

@onready var hitbox: HitboxComponent = $HitboxComponent


func _ready() -> void:
	hitbox.hit.connect(on_hitbox_hit)
	
	# A 1 in a 1000 chance of becoming cheese
	var rand_chance: bool = (randi_range(1, 1000)) == 1
	if rand_chance:
		anim_sprite.visible = false
		cheese_sprite.visible = true


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
