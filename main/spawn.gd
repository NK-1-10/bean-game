extends Area2D

@onready var timer = $Timer
@onready var food = $food

var spawned = 0

func _ready() -> void:
	Signals.pickUpFood.connect(picked_up)
	food.visible = false
	food.get_node("Area2D").monitoring = false
	timer.start()

func picked_up():
	spawned = spawned -1

func _on_timer_timeout() -> void:
	if spawned >= 5: return
	spawned += 1
	var new_food = food.duplicate()
	new_food.visible = true
	new_food.get_node("Area2D").monitoring = true
	add_child(new_food)
	new_food.global_position = random_point_in_spawn()

func random_point_in_spawn() -> Vector2:
	var shapes = get_children().filter(func(c): return c is CollisionShape2D)
	var cs = shapes.pick_random()
	var half = cs.shape.size / 2
	var local = Vector2(randf_range(-half.x, half.x), randf_range(-half.y, half.y))
	return cs.global_transform * local
