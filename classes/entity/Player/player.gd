extends Entity
class_name Player

signal eat_cheese
signal moving
signal sitting

@export var joystick: ControlJoystick

# I'm too lazy lol
# What I could have done is have an autoloader that contains these
#costumes for me. And once the player is created, I could just
#randomize the costumes!
@export var dark_birthday_anim_spite: SpriteFrames
@export var birthday_anim_spite: SpriteFrames
@export var cheese_birthday_hat: CompressedTexture2D
@export var dark_birthday_hat: CompressedTexture2D
@export var birthday_hat: CompressedTexture2D

var speed_base: float = 170.0
var speed_running: float = 315.0

@onready var state_machine: StateMachine = $StateMachine
@onready var hitbox: HitboxComponent = $HitboxComponent

@onready var anim_sprite := %AnimatedSprite2D
@onready var hat := %HatSprite
@onready var running_particles := %RunningParticles
@onready var cheese_particles := %CheeseParticles
@onready var eaten_timer := %EatenTimer
@onready var yum_sound := %YumSound

@onready var hat_scale: Vector2 = hat.scale
var hat_scale_increment: Vector2 = Vector2(0.005, 0.005)

var pitch_max: float = 2.75
var pitch_increment: float = 0.005
var volume_min: float = -14.5
var volume_increment: float = 0.15
@onready var original_volume: float = yum_sound.volume_db
@onready var original_pitch: float = yum_sound.pitch_scale

var tween: Tween

func _ready() -> void:
	hitbox.hit.connect(on_hitbox_hit)
	eaten_timer.timeout.connect(on_eaten_timer_timeout)
	joystick.soft_tolerance.connect(on_joystick_soft_tolerance)
	joystick.hard_tolerance.connect(on_joystick_hard_tolerance)
	joystick.revert_center.connect(on_joystick_revert_center)
	eat_cheese.connect(on_self_eat_cheese)
	
	# Rng events
	var rng_value: int = Ultilities.rng.randi_range(1, 1000)
	if rng_value < 500:
		hat.texture = birthday_hat
	if rng_value < 250:
		anim_sprite.sprite_frames = birthday_anim_spite
	if rng_value == 1:
		hat.texture = cheese_birthday_hat


func _input(_event: InputEvent) -> void:
	hitbox.active = Input.is_action_pressed("player_action") 


func change_speed(running: bool = false) -> void:
	current_speed = speed_running if running else speed_base


func get_movement_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


#Signals
func on_hitbox_hit() -> void:
	eat_cheese.emit()


func on_joystick_soft_tolerance(direction: Vector2) -> void:
	move_direction = direction
	hitbox.active = false
	state_machine.change_state($StateMachine/WalkState)


func on_joystick_hard_tolerance(direction: Vector2) -> void:
	move_direction = direction
	hitbox.active = true
	state_machine.change_state($StateMachine/RunState)


func on_joystick_revert_center() -> void:
	hitbox.active = false
	move_direction = Vector2.ZERO
	state_machine.change_state($StateMachine/IdleState)


func on_self_eat_cheese() -> void:
	cheese_particles.emitting = true
	eaten_timer.start()
	
	# Increases pitch in each eat
	yum_sound.play()
	yum_sound.pitch_scale = minf(yum_sound.pitch_scale + pitch_increment, pitch_max)
	yum_sound.volume_db = maxf(yum_sound.volume_db - volume_increment, volume_min)
	hat.scale += hat_scale_increment
	
	ScoreManager.increase_score()


func on_eaten_timer_timeout() -> void:
	cheese_particles.emitting = false
	yum_sound.pitch_scale = original_pitch
	yum_sound.volume_db = original_volume
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(hat, "scale", hat_scale, 0.2).set_trans(Tween.TRANS_BOUNCE)
