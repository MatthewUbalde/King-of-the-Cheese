extends PlayerState

#@export var idle_state: BaseState
@export var walk_state: BaseState
@export var run_state: BaseState
 
@onready var idle_anim_timer: Timer = %IdleAnimTimer

var sitting: bool = false

func _ready_state() -> void:
	super._ready_state()
	idle_anim_timer.timeout.connect(on_idle_anim_timer_timeout)


func _enter() -> void:
	super._enter()
	idle_anim_timer.start()


func _exit() -> void:
	super._exit()
	idle_anim_timer.stop()
	
	# If the player has been sitting, then emit that the player
	#is now moving!
	if sitting:
		player.moving.emit()
		sitting = false


func _physics_process_state(_delta : float) -> BaseState:
#	player.move_direction = player.get_movement_input()
	
	if player.get_movement_input() != Vector2.ZERO:
		if Input.is_action_pressed("move_run"):
			return run_state
		return walk_state
	
	return null


func on_idle_anim_timer_timeout() -> void:
	player.animation_player.play("sit")
	player.sitting.emit()
	sitting = true


func _to_string() -> String:
	return "IdleState"


func _show_properties() -> String:
	var property_text = """
	- global_position: %s
	- move_direction: %s"""
	return super._show_properties() + property_text % [player.global_position, player.move_direction] 
