extends ParallaxBackground

const SPEED_UP: float = 4.0 # Adds on to the speed_factor

@export var clouds_speed := 25.0
@export var speed_factor := 1.0

func _process(delta):
	scroll_base_offset -= Vector2(clouds_speed * speed_factor * SPEED_UP, 0) * delta 
