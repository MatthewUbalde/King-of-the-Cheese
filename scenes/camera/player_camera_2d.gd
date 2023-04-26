extends Camera2D

signal zoom_update(zoom_value: Vector2, message: String)

const ZOOM_MAX: Vector2 = Vector2(2.0, 2.0)
const ZOOM_MIN: Vector2 = Vector2(0.25, 0.25)
const ZOOM_INCREMENT: float = 0.25
const ZOOM_PRECISE_INCREMENT: float = 0.10
const MOUSE_SCROLL_DAMPING: float = 0.05

@export var player: Player
 
var tween: Tween
var zoom_value: Vector2 = Vector2.ONE
var mouse_axis: float = 0.0


func _input(event: InputEvent) -> void:
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
		return


func zoom_adjust(adjust: float) -> void:
	zoom_value = clamp(zoom_value + Vector2(adjust, adjust), ZOOM_MIN, ZOOM_MAX) 
	smooth_set_zoom(zoom_value)


func smooth_set_zoom(value: Vector2) -> void:
	if tween:
		tween.kill()

	tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", value, 0.4).set_trans(Tween.TRANS_CUBIC) 
