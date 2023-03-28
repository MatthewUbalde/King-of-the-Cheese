extends CharacterBody2D
class_name Entity

@export var visual: Node2D
@export var animation_player : AnimationPlayer

enum speed_type { WALK, RUN, ALTERNATE }
@export var speed_base := 64.0
@export var speed_running: float = 120.0

var move_direction: Vector2 = Vector2.ZERO
var current_speed: float = 0.0


func face_movement() -> void:
	var move_sign = sign(move_direction.x)
	if move_sign == 0:
		visual.scale.x = 1
	else:
		visual.scale.x = move_sign 


func apply_speed(speed: float) -> void:
	velocity = speed * move_direction
