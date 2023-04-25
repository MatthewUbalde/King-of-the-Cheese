extends CharacterBody2D
class_name Entity

@export var state_machine: StateMachine
@export var visual: Node2D
@export var animation_player : AnimationPlayer

enum speed_type { WALK, RUN, ALTERNATE }
@export var speed_base := 64.0
@export var speed_running: float = 120.0

enum death_type { DEFAULT, EATEN, DELETE }

var move_direction: Vector2 = Vector2.ZERO
var prev_direction: Vector2 = move_direction
var current_speed: float = 0.0


func face_movement() -> void:
	var move_sign: int = 1
#	if move_direction.x != 0:
#		move_sign = sign(move_direction.x)
#	else:
#		move_sign = sign(prev_direction.x)
	move_sign = sign(prev_direction.x)
	
	
	if move_sign == 0:
		visual.scale.x = 1
	else:
		visual.scale.x = move_sign 


func apply_speed(speed: float) -> void:
	velocity = speed * move_direction


func _despawn(type: death_type = death_type.DEFAULT) -> void:  
	match type:
		death_type.DEFAULT: 
			if animation_player.has_animation("despawn"):
				animation_player.play("despawn")
		death_type.DELETE:
			if animation_player.has_animation("despawn"):
				animation_player.play("despawn") 
		death_type.EATEN: 
			if animation_player.has_animation("eaten"):
				animation_player.play("eaten")
		_:
			queue_free()
