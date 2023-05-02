extends CanvasLayer

signal speed_up(speed_factor: float)

@export var main_scene: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cloud_parallax_bg: ParallaxBackground = $CloudParallaxBackground

const SPEED_SCALE_NORMAL: float = 1.0
const SPEED_SCALE_FAST: float = 6.0

func _ready() -> void:
	# Hard coding in the queues due to an solution that I was trying to do
	# This is actually nice to understand, so I'm keeping it
	animation_player.queue("intro")
	animation_player.queue("godot_enter")
	animation_player.queue("godot_exit")
	animation_player.queue("mint_enter")
	animation_player.queue("mint_exit")
	animation_player.queue("exit")
	
	speed_up.connect(on_self_speed_up)


func _input(event: InputEvent) -> void: 
	if event.is_pressed():
		animation_player.set_speed_scale(SPEED_SCALE_FAST)
		speed_up.emit(SPEED_SCALE_FAST)
	else:
		animation_player.set_speed_scale(SPEED_SCALE_NORMAL)
		speed_up.emit(SPEED_SCALE_NORMAL)


func change_to_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)


func on_self_speed_up(speed_factor: float):
	cloud_parallax_bg.speed_factor = speed_factor * cloud_parallax_bg.SPEED_UP
