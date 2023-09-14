extends ParallaxBackground

const SPEED_UP: float = 4.0 # Adds on to the speed_factor outside of this object

var clouds_speed := 35.0
var speed_factor := 1.0

func _process(delta):
	scroll_base_offset -= Vector2(clouds_speed * speed_factor, 0) * delta 
