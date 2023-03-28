extends Node
class_name BaseState

@export var anim_enter_name: StringName
@export var anim_exit_name: StringName

var entity: Entity

func _ready_state() -> void:
	pass


func _enter() -> void:
	pass


func _exit() -> void:
	pass


func _input_state(event: InputEvent) -> BaseState:
	return null


func _process_state(delta: float) -> BaseState:
	return null


func _physics_process_state(delta: float) -> BaseState:
	return null


func _to_string() -> String:
	return "BaseState"


func _show_properties() -> String:
	return _to_string() + " Properties"
