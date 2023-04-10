extends ParallaxBackground

@export var clouds_speed := 100.0

@onready var clouds_layer := %CloudsLayer

func _process(delta):
	scroll_base_offset -= Vector2(clouds_speed, 0) * delta
