extends ParallaxBackground

@export var clouds_speed := 25.0


func _process(delta):
	scroll_base_offset -= Vector2(clouds_speed, 0) * delta
