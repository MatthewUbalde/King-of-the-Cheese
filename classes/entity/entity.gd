extends Node2D
class_name Entity

@export var visual: Node2D
@export var animation_player : AnimationPlayer

var move_direction: Vector2 = Vector2.ONE
#var prev_direction: Vector2 = move_direction
#var speed_penalty: float = 1.0 # Meaning no penalty
var current_speed: float = 0.0

# Switching to Node2D, not planning for interatable environments!
var velocity: Vector2


func clamp_global_position() -> void:
	global_position.x = clamp(global_position.x, Ultilities.ARENA_SIZE[0], Ultilities.ARENA_SIZE[1])
	global_position.y = clamp(global_position.y, Ultilities.ARENA_SIZE[0], Ultilities.ARENA_SIZE[1])


func check_out_of_boundary() -> bool:
#	return global_position.x < Ultilities.ARENA_SIZE[0] || global_position.x > Ultilities.ARENA_SIZE[1] && global_position.y < Ultilities.ARENA_SIZE[0] || global_position.y > Ultilities.ARENA_SIZE[1]
	return int(global_position.x < Ultilities.ARENA_SIZE[0]) + int(global_position.x > Ultilities.ARENA_SIZE[1]) + int(global_position.y < Ultilities.ARENA_SIZE[0]) + int(global_position.y > Ultilities.ARENA_SIZE[1])


func face_movement() -> void:
	if move_direction.x != 0:
		visual.scale.x = sign(move_direction.x)


func apply_speed(speed: float) -> void:
	velocity = speed * move_direction 


func apply_velocity(delta: float) -> void:
	global_position += delta * velocity
