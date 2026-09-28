extends Node2D
@onready var food = $food
@onready var water = $water
@onready var can = $can

var holding = true

func _ready() -> void:
	Signals.inventory_slot.connect(check)
	food.visible = false ; water.visible = false ; can.visible = false

func check(slot):
	stop_hover()
	food.visible = false ; water.visible = false ; can.visible = false
	var key = str(slot)
	if not Global.inventory.has(key): return
	var item = Global.inventory[key]["name"]
	if item == "wateringcan":
		hover(can)
	elif item == "water":
		hover(water)
	elif item == "food":
		hover(food)

var hover_tween
func hover(what):
	what.visible = true
	if hover_tween: hover_tween.kill()
	what.position = Vector2(-0.5, -13)
	hover_tween = create_tween().set_loops()
	hover_tween.tween_property(what, "position", Vector2(-0.5, -16), 0.7)
	hover_tween.tween_property(what, "position", Vector2(-0.5, -13), 0.7)

func stop_hover():
	if hover_tween: hover_tween.kill()
