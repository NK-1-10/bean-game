extends Area2D

@onready var plant = $"../../../plant"
@onready var place = $".."
@onready var plants_holder = $"../../../plants"
@onready var bean = $"../../../beanstock"

var offset_half = 16

func _on_mouse_entered() -> void:
	if not place.has_meta("id"): return
	if Global.Squares[place.get_meta("id")]["can_plant"]:
		get_parent().get_node("ColorRect").visible = true
	else: get_parent().get_node("red").visible = true

func _on_mouse_exited() -> void:
	get_parent().get_node("ColorRect").visible = false
	get_parent().get_node("red").visible = false


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not place.has_meta("id"): return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var slot = str(Global.Current_slot)
		if Global.inventory.has(slot) and Global.inventory[slot]["name"] == "plant" and Global.Squares[place.get_meta("id")]["can_plant"]:
			print("planting!")
			var new_plant = plant.duplicate()
			var id = place.get_meta("id")
			Global.block_around(id)
			plants_holder.add_child(new_plant)
			new_plant.get_node("needs").start()
			new_plant.global_position = place.global_position + place.size / 2
			get_parent().get_node("ColorRect").visible = false
			get_parent().get_node("red").visible = true
			get_node("../../..").use_item(Global.Current_slot)
		elif Global.inventory.has(slot) and Global.inventory[slot]["name"] == "bean" and Global.can_place_2x2(place.get_meta("id")):
			var id = place.get_meta("id")
			Global.block_2x2(id)
			bean.visible = true
			bean.global_position = place.global_position + Vector2(offset_half, offset_half) + place.size / 2
			get_node("../../..").use_item(Global.Current_slot)
			Signals.bean_planted.emit()
