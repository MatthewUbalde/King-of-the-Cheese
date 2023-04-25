extends Node
class_name CheeseManager

const SPAWN_MAX_RADIUS := 500.0
const SPAWN_MIN_RADIUS := 100.0
const SPAWN_TIMER_MIN := 0.15

@export var basic_cheese_scene: PackedScene
@export var center: Node2D

@onready var spawn_timer := $SpawnTimer

@onready var base_spawn_time: float = spawn_timer.wait_time 
var spawn_time = base_spawn_time

var cheese_amount_max: int = 0
var cheese_amount: int = 0


func get_cheese_amount_present() -> int:
	var cheese_nodes = get_tree().get_nodes_in_group("cheese")
	
	if cheese_nodes:
		return cheese_nodes.size()
	else:
		return 0


func check_cheese_amount_max(amount: int) -> int:
	return min(amount, Ultilities.CHEESE_AMOUNT_CAP[0])


func _ready() -> void:
	# This signal should run at startup, updating the cheese_max with the current_day
	GameEvents.update_day.connect(on_game_events_update_day)
	
	spawn_timer.timeout.connect(on_spawn_timer_timeout)


func _input(event: InputEvent) -> void: 
	if !event.is_action_pressed("cheat_dev"):
		return
	
	if event.is_action_pressed("ui_select"):
		spawn_cheese(1)
		print_debug("testing!")


func get_spawn_position() -> Vector2: 
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var random_radius: float = randf_range(SPAWN_MIN_RADIUS, SPAWN_MAX_RADIUS)
	return center.global_position + (random_direction.normalized() * random_radius)


func update_cheese(amount: int) -> void:
	cheese_amount_max = amount
	start_time_log(cheese_amount)


func spawn_cheese(quantity: int = 1) -> void:
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	for i in quantity:
		var cheese = basic_cheese_scene.instantiate() as CheeseBasic
		cheese.tree_exiting.connect(on_cheese_tree_exiting)
		
		entities_layer.add_child(cheese)
		cheese.global_position = get_spawn_position()


func despawn_cheese(quantity: int = 1) -> void: 
	var cheese_group = get_tree().get_nodes_in_group("cheese")
	if cheese_group == null:
		return
	
	for i in quantity:
		if i < cheese_group.size():
			var cheese_queue = cheese_group[i]
			
			if cheese_queue: 
				cheese_queue._despawn(Entity.death_type.DEFAULT)


func start_time_log(amount: int) -> void:
	spawn_timer.start(base_spawn_time / float(cheese_amount_max - amount) + SPAWN_TIMER_MIN) 
	#print("Wait time: " + str(spawn_timer.wait_time)) 


func cheese_manage() -> void:
	if cheese_amount_max == 0:
		despawn_cheese(cheese_amount)
		return
	
	#TODO: Unable to update the Current Cheese counter when queue_free-ing cheeses
	if cheese_amount > cheese_amount_max:
		var cheese_over_amount = abs(cheese_amount - cheese_amount_max)
		despawn_cheese(cheese_over_amount)
		
		cheese_amount = get_cheese_amount_present()
	elif cheese_amount < cheese_amount_max: # If not, spawn more!
		spawn_cheese()
		
		# Update the amount of cheese present and restart the timer
		cheese_amount = get_cheese_amount_present()
		start_time_log(cheese_amount)


#Signals
func on_cheese_tree_exiting() -> void:
	cheese_amount = get_cheese_amount_present()
	start_time_log(cheese_amount)


func on_spawn_timer_timeout() -> void:
	cheese_manage()


func on_game_events_update_day(current_day: int) -> void:
	cheese_amount_max = check_cheese_amount_max(current_day)
	cheese_manage()
	
	start_time_log(cheese_amount) 
