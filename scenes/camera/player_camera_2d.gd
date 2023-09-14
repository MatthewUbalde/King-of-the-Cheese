extends Camera2D

signal zoom_update(zoom_value: Vector2, message: String)

const ZOOM_MAX: Vector2 = Vector2(2.0, 2.0)
const ZOOM_MIN: Vector2 = Vector2(0.25, 0.25)
const ZOOM_INCREMENT: float = 0.25
const ZOOM_PRECISE_INCREMENT: float = 0.10
const MOUSE_SCROLL_DAMPING: float = 0.05

@export var player: Player
@export var shake_amount: float = 4.0
var shake_amount_addon: float = 0.0

@onready var shake_timer: Timer = $ShakeTimer 
@onready var shake_timer_wait_time: float = shake_timer.wait_time
var shake_wait_time_addon: float = 0.0

var tween_zoom: Tween
var tween_shake: Tween
var tween_insanity: Tween
var zoom_value: Vector2 = Vector2.ONE
#var zoom_value_insane: Vector2 = Vector2.ONE
var mouse_axis: float = 0.0

var default_offset: Vector2 = offset

func _ready() -> void:
	set_process(false)
	
	InsanityEvents.insane.connect(on_insanity_events_insane)
	InsanityEvents.madness.connect(on_insanity_events_madness)
	InsanityEvents.delusional.connect(on_insanity_events_delusional)
	InsanityEvents.wake_ending.connect(on_insanity_events_wake_ending)
	
	InsanityEvents.ended.connect(on_insanity_events_ended)
	
	player.eat_cheese.connect(on_player_eat_cheese)
	shake_timer.timeout.connect(on_shake_timer_timeout)

func _input(event: InputEvent) -> void:
	if InsanityEvents.in_madness:
		return
	
	# Reset
	if event.is_action_pressed("zoom_reset"):
		zoom_value = Vector2.ONE
		smooth_set_zoom(zoom_value)
		zoom_update.emit(zoom_value, "Camera Reset")
		return
	
	if event.is_action_pressed("zoom_in_precise"):
		zoom_adjust(ZOOM_PRECISE_INCREMENT)
		zoom_update.emit(zoom_value, "Camera Zoom (0.05x) in")
		return
	elif event.is_action_pressed("zoom_in"):
		zoom_adjust(ZOOM_INCREMENT)
		zoom_update.emit(zoom_value, "Camera Zoom (0.25x) in")
		return
	
	if event.is_action_pressed("zoom_out_precise"):
		zoom_adjust(-ZOOM_PRECISE_INCREMENT)
		zoom_update.emit(zoom_value, "Camera Zoom (0.05x) out")
		return
	elif event.is_action_pressed("zoom_out"):
		zoom_adjust(-ZOOM_INCREMENT)
		zoom_update.emit(zoom_value, "Camera Zoom (0.25x) out")
		return
	
	mouse_axis = Input.get_axis("zoom_scroll_out", "zoom_scroll_in")
	if mouse_axis != 0.0:
		zoom_adjust(mouse_axis * MOUSE_SCROLL_DAMPING)
		mouse_axis = 0.0 
		zoom_update.emit(zoom_value, "Camera Scroll")


func _process(_delta: float) -> void:
	offset = Vector2(Ultilities.rng.randf_range(-1.1, 1.1), Ultilities.rng.randf_range(-0.8, 0.8)) * shake_amount * shake_amount_addon


func zoom_adjust(adjust: float) -> void:
	zoom_value = clamp(zoom_value + Vector2(adjust, adjust), ZOOM_MIN, ZOOM_MAX)
	smooth_set_zoom(zoom_value)


func smooth_set_zoom(value: Vector2) -> void:
	if tween_zoom:
		tween_zoom.kill()

	tween_zoom = create_tween()
	tween_zoom.tween_property(self, "zoom", value, 0.4).set_trans(Tween.TRANS_CUBIC) 


func on_insanity_events_insane() -> void:
	# The madness started!
	set_process(true)
	shake_amount_addon = 2.5
	shake_wait_time_addon = 1.0


func on_insanity_events_madness() -> void:
	shake_amount_addon = 5.0
	shake_wait_time_addon = 2.5
	
	if tween_insanity:
		tween_insanity.kill()
	
	tween_insanity = create_tween()
	tween_insanity.tween_property(self, "zoom", Vector2(zoom_value.x + 0.5, zoom_value.y + 0.5), InsanityEvents.madness_wait_time)


func on_insanity_events_delusional() -> void:
	shake_amount_addon = 10.0
	shake_wait_time_addon = 2.75
	
	if tween_insanity:
		tween_insanity.kill()
	
	tween_insanity = create_tween()
	tween_insanity.tween_property(self, "zoom", Vector2(zoom_value.x + 1.0, zoom_value.y + 1.0), InsanityEvents.delusional_wait_time)


func on_insanity_events_wake_ending() -> void:
	shake_amount_addon = -2.0
	shake_wait_time_addon = 0.0
	
	if tween_insanity:
		tween_insanity.kill()
	
	tween_insanity = create_tween()
	tween_insanity.tween_property(self, "zoom", Vector2(zoom_value.x + 2.5, zoom_value.y + 2.5), InsanityEvents.game_ending_wait_time)


func on_insanity_events_ended() -> void:
	shake_amount_addon = 0.0
	shake_wait_time_addon = 0.0
	
	if tween_insanity:
		tween_insanity.kill()
	
	tween_insanity = create_tween()
	tween_insanity.tween_property(self, "zoom", Vector2(zoom_value.x, zoom_value.y), 0.5)


func on_shake_timer_timeout() -> void:
	if tween_shake:
		tween_shake.kill()
	
	tween_shake = create_tween()
	set_process(false)
	tween_shake.tween_property(self, "offset", default_offset, 0.1).set_trans(Tween.TRANS_BOUNCE)


func on_player_eat_cheese() -> void:
	# Shake the camera!
	set_process(true)
	shake_timer.start(shake_timer_wait_time + shake_wait_time_addon)
