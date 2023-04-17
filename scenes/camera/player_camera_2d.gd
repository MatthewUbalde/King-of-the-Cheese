extends Camera2D

const ZOOM_INCREMENT = 0.25

@export var player: Player

@onready var idle_timer: Timer = $IdleTimer

var tween 
var zoom_value
var mouse_axis: float = 0

func _ready() -> void:
	idle_timer.timeout.connect(on_idle_timer_timeout)


func zoom_adjust(adjust: float) -> void:
	zoom_value = clamp(zoom + Vector2(adjust, adjust), Vector2(.25, .25), Vector2(2.0, 2.0))


func _input(event: InputEvent) -> void:
	# Reset
	if event.is_action_pressed("zoom_reset"):
		zoom_adjust(1.0)
		return
	
	if event.is_action_pressed("zoom_in"):
		zoom_adjust(ZOOM_INCREMENT)
	elif event.is_action_pressed("zoom_out"):
		zoom_adjust(-ZOOM_INCREMENT)
	
	mouse_axis = Input.get_axis("zoom_scroll_out", "zoom_scroll_out")
	
	zoom += Vector2(mouse_axis, mouse_axis).normalized()
	mouse_axis = 0 


func _process(delta: float) -> void:
	if player.state_machine.current_state._to_string() == "IdleState":
		if idle_timer.is_stopped():
			print("start")
			idle_timer.start()


func center_smooth_pos() -> void:
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", player.global_position, 2)


func on_idle_timer_timeout() -> void:
	center_smooth_pos()
