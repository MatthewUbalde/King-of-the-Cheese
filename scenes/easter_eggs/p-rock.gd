extends Node2D


func _ready() -> void:
	$Area2D.body_entered.connect(on_area_2d_body_entered)


func on_area_2d_body_entered(body: Node2D) -> void:
	$AudioStreamPlayer2D.play()
