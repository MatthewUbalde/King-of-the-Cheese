extends Entity
class_name CheeseBasic

const SPEED_RAND_RANGE := 15.0

const SPEED_BASE := 75
const SPEED_INSANE := 125
const SPEED_MADNESS := 400
const SPEED_DELUSIONAL := 1000

const IDLE_WAIT_TIME_BASE := 2
const IDLE_WAIT_TIME_INSANE := 2.4
const IDLE_WAIT_TIME_MADNESS := 0.24
const IDLE_WAIT_TIME_DELUSIONAL := 0.024

const MOVE_WAIT_TIME_BASE := 5
const MOVE_WAIT_TIME_INSANE := 5.5
const MOVE_WAIT_TIME_MADNESS := 6.0
const MOVE_WAIT_TIME_DELUSIONAL := 0.0

const WAIT_TIME_RANGE: float = 2.0
#const WAIT_TIME_RANGE: float = 3.0

var idle_wait_time: float = 5.0 # Default
var move_wait_time: float = 3.0 # Default

#@export var visible_enabler_path : NodePath

var sound_player_child: SoundPlayer = null

@onready var state_machine : StateMachine = $StateMachine
@onready var hurtbox_component : HurtboxComponent = $HurtboxComponent
@onready var visible_notifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


#var dont_play_spawn_sound: bool = false # IT'S SO ANNOYING
var sound_reduction: float = 0.0
#var state_timer : Timer# = %StateTimer

#var enabler2d: VisibleOnScreenEnabler2D

#func _enter_tree() -> void:
#	state_timer = %StateTimer
#	# Create the VisibleOnScreenEnabler2D here!
#	#This is because putting it on the scenetree causes the
#	#condition !is_inside_tree() to be true. An error!
#
##	enabler2d = VisibleOnScreenEnabler2D.new()
##	enabler2d.enable_node_path = 
##
##	enabler2d.rect.size.x = 50
##	enabler2d.rect.size.y = 50
##	enabler2d.rect.position.x = -25
##	enabler2d.rect.position.y = -30


func _ready() -> void: 
	update_speed_insanity()
	randomize_move_direction()
	
	visual.visible = false
#	$AudioStreamPlayer2D.visible = false
#	state_machine.set_process(false)
#	state_machine.set_process_input(false)
#	state_machine.set_process_internal(false)
#	set_physics_process(false)
	
#	current_speed = speed_base + Ultilities.rng.randf_range(-speed_rand_range, speed_rand_range)
	
	InsanityEvents.insane.connect(update_speed_insane, Object.ConnectFlags.CONNECT_DEFERRED)
	InsanityEvents.madness.connect(update_speed_madness, Object.ConnectFlags.CONNECT_DEFERRED)
	InsanityEvents.delusional.connect(update_speed_delusional, Object.ConnectFlags.CONNECT_DEFERRED)
	InsanityEvents.ended.connect(reset_speed, Object.ConnectFlags.CONNECT_DEFERRED)
	
	hurtbox_component.hurt.connect(on_hurtbox_component_hurt)
	visible_notifier.screen_entered.connect(on_visible_notifier_screen_entered)
	visible_notifier.screen_exited.connect(on_visible_notifier_screen_exited)
	animation_player.animation_finished.connect(on_annimation_player_animation_finished)
	
	animation_player.play("spawn")


func randomize_move_direction() -> void:
	move_direction = Vector2.RIGHT.rotated(Ultilities.rng.randf_range(0, TAU))  


func despawn() -> void:
	animation_player.play("despawn")


func update_speed_insanity() -> void:
	if !InsanityEvents.in_madness:
		reset_speed()
	else:
		if InsanityEvents.current_state == InsanityEvents.InsanityState.INSANE:
			update_speed_madness()
		elif InsanityEvents.current_state == InsanityEvents.InsanityState.MADNESS:
			update_speed_madness()
		elif InsanityEvents.current_state == InsanityEvents.InsanityState.DELUSIONAL:
			update_speed_delusional()


func reset_speed() -> void:
	current_speed = SPEED_BASE 
	idle_wait_time = IDLE_WAIT_TIME_BASE
	move_wait_time = MOVE_WAIT_TIME_BASE
	animation_player.speed_scale = 1.0


func update_speed_insane() -> void:
	current_speed = SPEED_INSANE
	idle_wait_time = IDLE_WAIT_TIME_INSANE
	move_wait_time = MOVE_WAIT_TIME_INSANE
	
	animation_player.speed_scale = SPEED_INSANE / current_speed + 1


func update_speed_madness() -> void:
	current_speed = SPEED_MADNESS
	idle_wait_time = IDLE_WAIT_TIME_MADNESS
	
	animation_player.speed_scale = SPEED_MADNESS / current_speed + 1


func update_speed_delusional() -> void:
	current_speed = SPEED_DELUSIONAL
	idle_wait_time = IDLE_WAIT_TIME_DELUSIONAL
	move_wait_time = MOVE_WAIT_TIME_DELUSIONAL
	
	animation_player.speed_scale = SPEED_DELUSIONAL / current_speed + 1


func add_sound_child() -> void:
	sound_player_child = ScenePackages.cheese_sounds_player.instantiate()
	add_child(sound_player_child)


func play_sound_is_that_okay() -> void: # spawn
	if sound_player_child != null:
		sound_player_child.play_sound_vol(SoundResources.IS_THAT_OKAY, sound_reduction - 5.0)


func play_sound_cheese_step() -> void: # move
	if sound_player_child != null:
		sound_player_child.play_sound(SoundResources.CHEESE_STEP)


func play_sound_okay() -> void: # idle AND despawn
	if sound_player_child != null:
		sound_player_child.play_sound_vol(SoundResources.OKAY, -12.0)


func play_sound_no() -> void: # eaten
	if sound_player_child != null:
		sound_player_child.play_sound_vol(SoundResources.NO, 12.0)


func remove_sound_child() -> void:
	if sound_player_child != null:
		sound_player_child.queue_free()
		sound_player_child = null


func on_hurtbox_component_hurt() -> void:
	var eat_particles: CPUParticles2D = ScenePackages.eat_particle_scene.instantiate()
	add_child(eat_particles)
	eat_particles.emitting = true
	
	animation_player.play("eaten")


func on_visible_notifier_screen_entered() -> void:
	visual.visible = true
	hurtbox_component.visible = true
	animation_player.play()


func on_visible_notifier_screen_exited() -> void:
	visual.visible = false
	hurtbox_component.visible = false
	animation_player.pause()


func on_annimation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "eaten" || anim_name == "despawn":
		queue_free()
