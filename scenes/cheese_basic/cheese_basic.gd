extends Entity
class_name CheeseBasic

@export var navigation_radius := 200.0 
@export var speed_rand_range := 10.0

@export var navigation_wait_time_range := 2.0
@export var idle_wait_time_range := 3.0

@onready var navigation_timer := $NavigationTimer
@onready var idle_timer := $IdleTimer
  
@onready var navigation_wait_time_base: float = navigation_timer.wait_time
@onready var idle_wait_time_base: float = idle_timer.wait_time


func range_rand_value(base: float, range: float) -> float:
	return base + randf_range(-range, range)


func _ready() -> void:
	navigation_timer.timeout.connect(on_navigation_timer_timeout) 
	idle_timer.timeout.connect(on_idle_timer_timeout) 
	animation_player.animation_finished.connect(on_animation_player_animation_finished)
	
	current_speed = range_rand_value(speed_base, speed_rand_range)
	$SpawnSound.pitch_scale = range_rand_value(1, 0.35)
#	idle_timer.start()
#	animation_player.play("idle")


func _physics_process(delta: float) -> void: 
	if navigation_timer.is_stopped():
		return
	
	apply_speed(current_speed)
	
	face_movement()


func on_navigation_timer_timeout() -> void:
	move_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))  
	idle_timer.start(range_rand_value(idle_wait_time_base, idle_wait_time_range))
	animation_player.play("idle")


# Does nothing but idles
func on_idle_timer_timeout() -> void:
	navigation_timer.start(range_rand_value(navigation_wait_time_base, navigation_wait_time_range))
	$IdleSound.pitch_scale = range_rand_value(1, 0.35)
	animation_player.play("walking")


func on_animation_player_animation_finished(anim_name: StringName) -> void: 
	if anim_name != "spawn":
		return
	
	idle_timer.start(range_rand_value(idle_wait_time_base, idle_wait_time_range))
	animation_player.play("idle") 


func play_despawn() -> void:
	animation_player.play("despawn")
