extends CharacterBody2D

@export var camera_controller: Camera2D


@export var speed_running:= 125.0


func _input(event: InputEvent): 
	pass


func _physics_process(delta):
	var moving_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = moving_direction.normalized() * speed_running
	
	move_and_slide() 

