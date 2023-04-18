extends Camera2D

const ZOOM_INCREMENT = 0.25
const MOUSE_SCROLL_DAMPING = 0.05

@export var player: Player
 
var tween: Tween
var prev_global_position: Vector2 = global_position
var zoom_value: Vector2 = Vector2.ONE
var mouse_axis: float = 0.0

func zoom_adjust(adjust: float) -> void:
	zoom_value = clamp(zoom_value + Vector2(adjust, adjust), Vector2(.25, .25), Vector2(2.0, 2.0))
	#zoom = zoom_value
	smooth_set_zoom(zoom_value)


func _input(event: InputEvent) -> void:
	# Reset
	if event.is_action_pressed("zoom_reset"):
		smooth_set_zoom(Vector2.ONE)
		print_debug("Camera Reset!")
		return
	
	if event.is_action_pressed("zoom_in"):
		zoom_adjust(ZOOM_INCREMENT)
		print_debug("Camera Zoom in")
		return
	
	if event.is_action_pressed("zoom_out"):
		zoom_adjust(-ZOOM_INCREMENT)
		print_debug("Camera Zoom out")
		return
	
	mouse_axis = Input.get_axis("zoom_scroll_out", "zoom_scroll_in")
	if mouse_axis != 0.0:
		zoom_adjust(mouse_axis * MOUSE_SCROLL_DAMPING)
		mouse_axis = 0.0 
		print_debug("Camera Scroll")
		return


func smooth_set_zoom(value: Vector2) -> void:
	if tween:
		tween.kill()

	tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", value, 0.4).set_trans(Tween.TRANS_CUBIC)
	print_debug("Smoothing")
