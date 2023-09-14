extends Node
class_name CheeseManager

const SPAWN_MAX_RADIUS := 650.0
const SPAWN_MIN_RADIUS := 65.0

@export var basic_cheese_scene: PackedScene
@export var center: Node2D

@onready var spawn_timer := $SpawnTimer

#@onready var base_spawn_time: float = spawn_timer.wait_time 
#var spawn_time: float = base_spawn_time

var bypass_limit: bool = false
var amount_max: int = Ultilities.CHEESE_AMOUNT_CAP[0]
var current_amount: int = 0

@onready var entities_layer: Node2D = get_tree().get_first_node_in_group("entities_layer")
@onready var cheese_group: Array[Node]


func _ready() -> void:
	# This signal should run at startup, updating the cheese_max with the current_day
	GameEvents.update_day.connect(on_game_events_update_day)
	spawn_timer.timeout.connect(on_spawn_timer_timeout)


func _input(event: InputEvent) -> void: 
	if !event.is_action_pressed("cheat_dev"):
		return
	
	if event.is_action_pressed("ui_select"):
		spawn_cheese()


func get_spawn_position() -> Vector2: 
	return center.global_position + Vector2.RIGHT.rotated(randf_range(0, TAU)).normalized() * randf_range(SPAWN_MIN_RADIUS, SPAWN_MAX_RADIUS)


func update_cheese(amount: int) -> void:
	amount_max = amount


func spawn_cheese() -> void:
	var cheese: CheeseBasic = basic_cheese_scene.instantiate()
	
	entities_layer.add_child(cheese)
	cheese.tree_exiting.connect(on_cheese_tree_exiting)
	cheese.global_position = get_spawn_position()
	cheese.clamp_global_position()


func spawn_cheese_amount(quantity: int) -> void:
	var sound_reduction: float = -1.5 * amount_max / 25
	
	for i in quantity:
		# Function calls are a bit expensive, so I decided to just copy and paste it
		var cheese: CheeseBasic = basic_cheese_scene.instantiate()
		
		cheese.sound_reduction = sound_reduction
		entities_layer.add_child(cheese)
		cheese.tree_exiting.connect(on_cheese_tree_exiting)
		cheese.global_position = get_spawn_position()
		cheese.clamp_global_position()


func despawn_cheese() -> void: 
	cheese_group.back().despawn()


func despawn_cheese_amount(quantity: int) -> void:
	for i in quantity:
		if cheese_group[i] != null:
			cheese_group[i].despawn()


func cheese_manage() -> void:
	if amount_max == 0:
		despawn_cheese_amount(current_amount)
	elif current_amount > amount_max:
		var cheese_over_amount: int = current_amount - amount_max
		despawn_cheese_amount(cheese_over_amount)
	elif current_amount < amount_max:
		spawn_cheese()
	
	cheese_group = get_tree().get_nodes_in_group("cheese")
	current_amount = cheese_group.size()


func spawn_cheese_instantly() -> void:
	var cheese_spawn: int = amount_max - current_amount
	if cheese_spawn > 0:
		spawn_cheese_amount(cheese_spawn)


#Signals
func on_cheese_tree_exiting() -> void:
	current_amount -= 1 # If it's inaccurate, it'll get updated anyway in the next timeout


func on_spawn_timer_timeout() -> void:
	cheese_manage()


func on_game_events_update_day(current_day: int, _current_date: Dictionary) -> void:
	amount_max = current_day
	cheese_manage()
