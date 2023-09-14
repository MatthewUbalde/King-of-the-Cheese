extends Node2D
class_name ControlJoystick

signal hard_tolerance(direction: Vector2)
signal soft_tolerance(direction: Vector2)
signal revert_center

@export var use_timer_wait_time: float = 0.75
@export var distance_soft_tolerance: float = 75
@export var distance_hard_tolerance: float = 3900

@onready var sprite_origin: Sprite2D = $SpriteOrigin
@onready var sprite_end: Sprite2D = $SpriteEnd
@onready var joystick: Sprite2D = $Joystick
@onready var active_timer: Timer = $ActiveTimer

var tween: Tween
var distance: float
var active : bool
var moving: bool
#var moving : bool = false

func _ready() -> void:
#	hard_tolerance.connect(on_change_direction)
#	soft_tolerance.connect(on_change_direction)
	
	hard_tolerance.connect(on_self_hard_tolerance)
	soft_tolerance.connect(on_self_soft_tolerance)
	revert_center.connect(on_self_revert_center)
	
	active_timer.timeout.connect(on_active_timer_timeout)
	
	active = false
	moving = false
	if Input.is_action_just_released("move_here"):
		input_mouse_released()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_pressed("move_here"):
		input_mouse_pressed()
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		sprite_origin.visible = false
		sprite_end.visible = false
		joystick.visible = false
	
	sprite_origin.position = get_local_mouse_position()
	joystick.position = sprite_origin.position
	sprite_end.position = sprite_origin.position
	
	active_timer.wait_time = use_timer_wait_time


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_cancel"):
		revert_center.emit()
		deactiviate_joystick()
	else:
		# If the joystick is not active, then make it active!
		if event.is_action_pressed("move_here"):
			input_mouse_pressed()
		elif event.is_action_released("move_here") && active:
			input_mouse_released()


func input_mouse_pressed() -> void:
	moving = true
	
	sprite_origin.visible = true
	sprite_end.visible = true
	joystick.visible = true
	
	set_physics_process(true)
	
	if !active:
		sprite_origin.position = get_local_mouse_position()
		joystick.position = sprite_origin.position
		
		active = true
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		active_timer.stop()


func input_mouse_released() -> void:
	moving = false
	active_timer.start()


func _physics_process(_delta: float) -> void:
	sprite_end.position = get_local_mouse_position()
	
	# Tolerances
	distance = sprite_origin.position.distance_squared_to(sprite_end.position)
	
	if distance < distance_soft_tolerance:
		revert_center.emit()
	elif distance < distance_hard_tolerance:
		soft_tolerance_tween()
		if moving:
			soft_tolerance.emit(Vector2.from_angle(sprite_origin.position.angle_to_point(sprite_end.position)))
	else:
		hard_tolerance_tween()
		if moving:
			hard_tolerance.emit(Vector2.from_angle(sprite_origin.position.angle_to_point(sprite_end.position)))
	
	sprite_origin.look_at(sprite_end.position)
	sprite_end.look_at(sprite_origin.position)


func deactiviate_joystick() -> void:
	if tween: 
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(sprite_end, "modulate:a", 0.0, 0.1)
	tween.parallel().tween_property(joystick, "modulate:a", 0.0, 0.1)
	tween.parallel().tween_property(sprite_origin, "modulate:a", 0.0, 0.1)
	
	set_physics_process(false)
	
	active = false
	moving = false
	active_timer.stop()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func soft_tolerance_tween() -> void:
	if tween: 
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite_end, "scale", Vector2(0.6, 0.6), 0.05)
	tween.parallel().tween_property(sprite_end, "modulate:a", 0.0, 0.1)
	tween.parallel().tween_property(joystick, "modulate:a", 0.1, 0.1)
	tween.parallel().tween_property(sprite_origin, "modulate:a", 0.8, 0.05)
	
	tween.parallel().tween_property(sprite_origin, "scale", Vector2(0.75, 0.75), 0.1)
	tween.parallel().tween_property(joystick, "scale", Vector2(0.8, 0.8), 0.2)


func hard_tolerance_tween() -> void:
	if tween: 
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite_end, "scale", Vector2(1.5, 1.5), 0.025)
	tween.parallel().tween_property(sprite_end, "modulate:a", 0.8, 0.05)
	tween.parallel().tween_property(joystick, "modulate:a", 0.75, 0.05)
	
	tween.parallel().tween_property(sprite_origin, "modulate:a", 1.0, 0.05)
	tween.parallel().tween_property(sprite_origin, "scale", Vector2(1.2, 1.2), 0.05)
	tween.parallel().tween_property(joystick, "scale", Vector2(1.1, 1.1), 0.025)


func revert_center_tween() -> void:
	if tween: 
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite_end, "modulate:a", 0.0, 0.05)
	tween.parallel().tween_property(joystick, "modulate:a", 0.1, 0.05)
	tween.parallel().tween_property(sprite_origin, "modulate:a", 0.0, 0.05)


func on_self_hard_tolerance(_direction: Vector2) -> void:
	hard_tolerance_tween()


func on_self_soft_tolerance(_direction: Vector2) -> void:
	soft_tolerance_tween()


func on_self_revert_center() -> void:
	if active:
		revert_center_tween()


func on_active_timer_timeout() -> void:
	deactiviate_joystick()
