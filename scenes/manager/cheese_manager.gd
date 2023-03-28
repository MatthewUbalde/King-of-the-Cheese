extends Node
class_name CheeseManager
 
signal amount_update(amount: int)

const SPAWN_MAX_RADIUS := 300.0
const SPAWN_MIN_RADIUS := 40.0

@export var basic_cheese_scene: PackedScene
@export var center: Node2D

@onready var spawn_timer := $SpawnTimer

@onready var cheese_amount_max := GameEvents.current_day
@onready var base_spawn_time: float = spawn_timer.wait_time
var cheese_amount := 0
var cheese_amount_old := cheese_amount


func get_cheese_amount_present() -> int:
	return get_tree().get_nodes_in_group("cheese").size()


func _ready() -> void:
	GameEvents.update_day.connect(on_game_events_update_day)
	
	spawn_timer.timeout.connect(on_spawn_timer_timeout) 


func get_spawn_position() -> Vector2: 
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var random_radius: float = randf_range(SPAWN_MIN_RADIUS, SPAWN_MAX_RADIUS)
	return center.global_position + (random_direction.normalized() * random_radius)


func update_cheese(amount: int) -> void:
	cheese_amount_max = amount
	spawn_timer.start() 


func spawn_cheese(quantity: int = 1) -> void:
	for i in quantity:
		var cheese = basic_cheese_scene.instantiate() as Node2D
		
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
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
				cheese_queue.play_despawn()


func cheese_manage() -> void:
	#TODO: Unable to update the Current Cheese counter when queue_free-ing cheeses
	if cheese_amount > cheese_amount_max:
		var cheese_over_amount = abs(cheese_amount - cheese_amount_max)
		despawn_cheese(cheese_over_amount)
	elif cheese_amount < cheese_amount_max: # If not, spawn more!
		spawn_cheese()
		spawn_timer.start() 
	
	#print("timeout=")
	emit_amount_update()


func _process(delta: float) -> void:
	# Check for any changes to the cheese_amount
	if cheese_amount != cheese_amount_old:
		#print("process==")
		emit_amount_update(get_cheese_amount_present(), true)


#Signals
func on_spawn_timer_timeout() -> void:
	cheese_manage()


func on_game_events_update_day(current_day: int) -> void:
	cheese_amount_max = current_day
	cheese_manage()
	
	spawn_timer.start()


func emit_amount_update(amount: int = get_cheese_amount_present(), keep_old: bool = false) -> void:
	cheese_amount = amount
	amount_update.emit(cheese_amount)
	#print("new: " + str(cheese_amount))
	
	if keep_old:
		cheese_amount_old = cheese_amount
		#print("old: " + str(cheese_amount_old))
