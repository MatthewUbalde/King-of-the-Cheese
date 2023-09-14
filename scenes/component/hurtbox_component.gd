extends Area2D
class_name HurtboxComponent

signal hurt

# This is used with the AudioThread performance problem!
@export var parent: CheeseBasic 
@export var collision_shape: CollisionShape2D

var hitbox_component: HitboxComponent


func _ready() -> void:
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	hurt.connect(on_self_hurt)
	
#	collision_shape.disabled = false
	set_process(false)


func _process(_delta: float) -> void:
	if hitbox_component.active:
		hurt.emit()


func on_area_entered(other_area: Area2D) -> void:
	if other_area is HitboxComponent:
		hitbox_component = other_area
		set_process(true)


func on_area_exited(_other_area: Area2D) -> void: 
	hitbox_component = null
	set_process(false)


func on_self_hurt() -> void:
	set_process(false)
	collision_shape.disabled = true
	hitbox_component.hit.emit()
