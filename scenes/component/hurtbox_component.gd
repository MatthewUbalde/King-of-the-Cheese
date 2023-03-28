extends Area2D
class_name HurtboxComponent

@export var entity: Entity


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if entity == null:
		return
	
	var hitbox = other_area as HitboxComponent
	if hitbox.active:
		hitbox.hit.emit()
		entity._despawn()
